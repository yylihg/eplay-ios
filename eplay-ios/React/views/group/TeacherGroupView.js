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
    StyleSheet,
    NativeModules,
    Image
} from 'react-native';
import SearchView from '../common/SearchView';
import React, {Component} from 'react';
import ListLine from '../common/ListLine';
var ReactModule = NativeModules.ReactModule;
const AnimatedFlatList = Animated.createAnimatedComponent(FlatList);
let currentIndex = 0;
let totalCount = 0;
let currentPage = 0;
import HeadViewWithLeftBtn from '../common/HeadViewWithLeftBtn';

var findNodeHandle = require('findNodeHandle');

export default class TeacherGroupView extends Component {

    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            groupBuyList: [],
            teacherId : ''
        }
    }

    componentDidMount() {
        var context = this;
        ReactModule.getItem("userInfo", function (result) {
            if (result && result.value){
                var userInfo = JSON.parse(result.value)
                context.setState({
                    teacherId:userInfo.USER_ID
                })
                context._getList(currentPage);
            }
        })
    }
    _getList = function (page) {
        var url = "/groupCourse/list.do?start="+page*10+"&pageSize=10&userId=" + this.state.teacherId;
        var context = this;
        ReactModule.fetch("get",{api:url},function (error, response) {
            console.log('ihg /groupCourse/list.do', response)
            if (error){
                currentPage -=1;
            }else {
                totalCount = response.data.total;
                currentIndex = context.state.groupBuyList.length;
                let groupBuyTemp = response.data.list || [];
                let groupBuyList = currentPage == 0? []:context.state.groupBuyList;
                for (let i = 0; i < groupBuyTemp.length; i++){
                    groupBuyTemp[i].key = currentIndex + "";
                    currentIndex += 1;
                    groupBuyList.push(groupBuyTemp[i]);
                }
                context.setState({
                    groupBuyList: groupBuyList
                });
            }
        });
    }

    render() {
        return (
            <View>
                <HeadViewWithLeftBtn title = "个人中心"></HeadViewWithLeftBtn>
                <AnimatedFlatList
                    style = {{marginBottom: 100}}
                    data={this.state.groupBuyList}
                    renderItem={this._renderItemComponent}
                    onEndReached={this._onEndReached}
                    onRefresh={this._onRefresh}
                    refreshing={false}
                />
            </View>
        );
    }

    _onItemPress(item) {
        ReactModule.pushReactViewController(findNodeHandle(this), "TeacherGroupBuyDetailPage", item);
    }

    _renderItemComponent = ({item, separators}) => {
        return (
            <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onItemPress(item)}>
                <View>
                    <View style={styles.listItemContainer}>
                        <Image style={styles.listItemImage} source={{uri: item.TEACHER_IMG_URL}}/>
                        <View style={styles.listItemText}>
                            <Text style={styles.listItemTitle}>{item.ORDER_NAME}</Text>
                            <Text numberOfLines={2} style={styles.listItemDes}>{item.TEACHER_EXPERIENCE}</Text>
                        </View>
                    </View>
                    <ListLine style ={styles.listItemLine}/>
                </View>
            </TouchableHighlight>
        );
    };

    _onEndReached = () => {
        if (this.state.groupBuyList.length < 9) {
            return;
        }
        if (this.state.groupBuyList.length < totalCount){
            currentPage += 1;
            this._getList(currentPage);
        }
    };
    _onRefresh = () => {
        currentPage = 0;
        this._getList(currentPage);
    }
}

const styles = StyleSheet.create({
    selectBtn: {
        backgroundColor: '#0168ae',
        justifyContent:'center',
        alignItems: 'center',
        borderRadius: 5,
        width: 45,
        marginTop: 10,
        marginRight: 10,
        height: 30,
    },
    selectBtnText: {
        color: '#fff',
        fontSize: 14
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
        marginTop: 8,
        color: '#999'
    },
    listItemLine: {
        position:'absolute',
        bottom: 0
    }
});

