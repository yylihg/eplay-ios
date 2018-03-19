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
var findNodeHandle = require('findNodeHandle');

class BookedView extends Component {

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
        ReactModule.fetch("get", {api: "/course/list.do?start=" + page*10 + "&pageSize=10&orderStatusType=DOING"}, function (error, response) {
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
            <View style={{flex: 1}}>
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
                            <Text style={styles.listItemDes}>{item.TEACHER_EXPERIENCE}</Text>
                        </View>
                        <TouchableHighlight underlayColor = '#eee' style={styles.cancelBtn} onPress={()=>this._onCancelCource(item)}>
                             <Text style={styles.cancelBtnText}>取消</Text>
                        </TouchableHighlight>
                        {
                            item.CAN_START_TIME?<TouchableHighlight underlayColor = '#eee' style={styles.selectBtn} onPress={()=>this._onSureChangeTime(item)}>
                                   <Text style={styles.cancelBtnText}>同意协调</Text>
                            </TouchableHighlight>:<Text></Text>
                        }
                    </View>
                    <ListLine style ={styles.listItemLine}/>
                </View>
            </TouchableHighlight>
        );
    };

    _onCancelCource(item){
        var context = this;
        let url = "";
            url = "/course/cancel.do?orderId=" + item.ORDER_ID;
        var mCources = [];
        for (let i = 0; i < context.state.cources.length; i++) {
            if (item.key != context.state.cources[i].key){
                var cource = context.state.cources[i];
                cource.key = i;
                mCources.push(cource);
            }
        }
        context.setState({
            cources: mCources
        })
        ReactModule.fetch("get", {api: url}, function (error, response) {
            console.log('ihg ' + url, response)
            if (error) {

            } else {
            }
        });
    }


    _onSureChangeTime(item){
        var context = this;
        let url = "/course/takeOrder.do?orderId=" + item.ORDER_ID;
        ReactModule.fetch("get", {api: url}, function (error, response) {
            console.log('ihg ' + url, response)
            if (error) {

            } else {
                currentPage = 0;
                context._getBookedList(currentPage);
            }
        });
    }
    //
    //
    // _orderTime(){
    //     if (cource){
    //         ReactModule.pushReactViewController(findNodeHandle(this), "PickDatePage", {});
    //     }
    // }

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

    cancelBtn: {
        backgroundColor: '#d2d2d2',
        justifyContent:'center',
        alignItems: 'center',
        borderRadius: 5,
        paddingLeft: 10,
        paddingRight: 10,
        marginTop: 10,
        marginRight: 10,
        height: 30,
    },
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

export default BookedView;