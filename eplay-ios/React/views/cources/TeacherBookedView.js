/**
 * Created by yanlin.yyl.
 */
'use strict';

import  {
    View,
    Text,
    TouchableHighlight,
    Animated,
    FlatList,
    NativeModules,
    StyleSheet,
    Image
} from 'react-native';
import SearchView from '../common/SearchView';
import React, {Component} from 'react';

const AnimatedFlatList = Animated.createAnimatedComponent(FlatList);
let currentIndex = 0;
let totalCount = 0;
let currentPage = 0;
import ListLine from '../common/ListLine';
var ReactModule = NativeModules.ReactModule;
var ReactIMModule = NativeModules.ReactIMModule;
var findNodeHandle = require('findNodeHandle');


class TeacherBookedView extends Component {

    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            cources: []
        }
    }

    componentDidMount() {
        this._getBookedList(currentPage);
    }

    _getBookedList = function (page) {
        var context = this;
        ReactModule.fetch("get", {api: "/course/list.do?start=" + page*10 + "&pageSize=10&orderStatusType=DOING"
        + "&teacherUserId=" + "bd2da6a4bd79435f9256c49c7b2ec8f3"}, function (error, response) {
            console.log('ihg /course/list.do: ', response)
            if (error) {
                currentPage -= 1;
            } else {
                totalCount = response.data.total;
                currentIndex = context.state.cources.length;
                let bookedTemp = response.data.list || [];
                let bookedList = currentPage == 0 ? [] : context.state.cources;
                for (let i = 0; i < bookedTemp.length; i++) {
                    bookedTemp[i].key = currentIndex + "";
                    currentIndex += 1;
                    bookedList.push(bookedTemp[i]);
                }
                context.setState({
                    cources: bookedList
                });
            }
        });
    }

    render() {
        return (
            <View>
                <AnimatedFlatList
                    data={this.state.cources}
                    renderItem={this._renderItemComponent}
                    onEndReached={this._onEndReached}
                    onRefresh={this._onRefresh}
                    refreshing={false}
                />
            </View>
        );
    }

    _onItemPress(item) {
        // alert('click:' + JSON.stringify(item))
    }

    _renderItemComponent = ({item, separators}) => {
        return (
            <TouchableHighlight underlayColor='#eee' onPress={() => this._onItemPress(item)}>
                <View>
                    <View style={styles.listItemContainer}>
                        <Image style={styles.listItemImage} source={{uri: item.TEACHER_IMG_URL}}/>
                        <View style={styles.listItemText}>
                            <Text numberOfLines = {1} style={styles.listItemTitle}>{item.ORDER_NAME}</Text>
                            <Text numberOfLines={2}  style={styles.listItemDes}>{item.TEACHER_EXPERIENCE}</Text>
                        </View>
                        {
                            item.ORDER_STATUS == "0"?<TouchableHighlight style={styles.selectBtn} underlayColor = '#eee' onPress={()=>this._onOrder(item)}>
                                <Text style={styles.cancelBtnText}>接单</Text>
                            </TouchableHighlight>:<View></View>
                        }
                        {
                            item.ORDER_STATUS == "0"?<TouchableHighlight style={styles.selectBtn} underlayColor = '#eee' onPress={()=>this._onCoordinate(item)}>
                                <Text style={styles.cancelBtnText}>协调</Text>
                            </TouchableHighlight>:<View></View>
                        }
                        {
                            item.ORDER_STATUS == "1" ? item.TECH_MODE == "OUTLINE"?<TouchableHighlight style={styles.selectBtn} underlayColor = '#eee' onPress={()=>this._onFinishCource(item)}>
                                <Text style={styles.cancelBtnText}>上课完成</Text>
                            </TouchableHighlight>:<TouchableHighlight style={styles.selectBtn} underlayColor = '#eee' onPress={()=>this._onStartCource(item)}>
                                <Text style={styles.cancelBtnText}>开始</Text>
                            </TouchableHighlight>:<View/>
                        }
                        {
                            item.ORDER_STATUS == "1" ? item.TECH_MODE == "OUTLINE"?<View></View>:<TouchableHighlight style={styles.selectBtn} underlayColor = '#eee' onPress={()=>this._onStopCource(item)}>
                                <Text style={styles.cancelBtnText}>结束</Text>
                            </TouchableHighlight>:<View/>
                        }

                    </View>
                    <ListLine style ={styles.listItemLine}/>
                </View>
            </TouchableHighlight>
        );

    };

    _onOrder(item){
        var context = this;
        // item.ORDER_STATUS = 1;
        ReactModule.fetch("get", {api: "/course/takeOrder.do?orderId=" + item.ORDER_ID}, function (error, response) {
            console.log('ihg /course/takeOrder.do', response)
            if (error) {
            } else {

            }
        });
    }
    _onFinishCource(item){
        ReactModule.pushReactViewController(findNodeHandle(this), "FinishCourcePage", {orderId: item.ORDER_ID});
    }
    _onStartCource(item){
        ReactModule.fetch("get", {api: "/course/beginClass.do?orderId=" + item.ORDER_ID}, function (error, response) {
            console.log('ihg /course/beginClass.do' + response.data.data.IM_USERNAME, response)
            if (error) {

            } else {
                if (response && response.data && response.data.data && response.data.data.IM_USERNAME){
                    // ReactIMModule.pushSessionController(response.data.data.IM_USERNAME);
                }
            }
        });
    }
    _onStopCource(item){
        var context = this;
        ReactModule.fetch("get", {api: "/course/endClass.do?orderId=" + item.ORDER_ID}, function (error, response) {
            console.log('/course/endClass.do', response)
            if (error) {

            } else {
                currentPage = 0;
                context._getBookedList(currentPage);
            }
        });
    }
    _onCoordinate(item){
        ReactModule.pushReactViewController(findNodeHandle(this), "ModifyCourceTimePage", {orderId: item.ORDER_ID});
    }

    _onEndReached = () => {
        if (this.state.cources.length < 9) {
            return;
        }
        if (this.state.cources.length < totalCount){
            currentPage += 1;
            this._getBookedList(currentPage);
        }
    };
    _onRefresh = () => {
        currentPage = 0;
        this._getBookedList(currentPage);
    }


}
const styles = StyleSheet.create({
    selectBtn: {
        backgroundColor: '#0168ae',
        justifyContent:'center',
        alignItems: 'center',
        borderRadius: 5,
        paddingLeft: 10,
        paddingRight: 10,
        marginTop: 10,
        marginRight: 10,
        height: 30,
    },
    cancelBtn: {
        backgroundColor: '#d2d2d2',
        justifyContent:'center',
        alignItems: 'center',
        borderRadius: 5,
        width: 45,
        marginTop: 10,
        marginRight: 10,
        height: 30,
    },
    cancelBtnText: {
        color: '#fff',
        fontSize: 16
    },

    listItemContainer: {
        height:66,
        flexDirection: 'row'
    },
    listItemImage: {
        marginLeft: 10,
        width: 68,
        height:50,
        marginTop: 8,
        marginBottom:8
    },
    listItemText: {
        flex: 1,
        marginLeft: 10,
        marginRight: 10,
        justifyContent: 'center'
    },
    listItemTitle: {
        fontSize: 14,
        color: '#666'
    },
    listItemDes: {
        fontSize: 12,
        marginTop: 4,
        color: '#999'
    },
    listItemLine: {
        position:'absolute',
        bottom: 0
    }
});

export default TeacherBookedView;