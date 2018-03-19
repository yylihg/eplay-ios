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


class FinishedView extends Component {

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
        ReactModule.fetch("get", {api: "/course/list.do?start=" + page*10 + "&pageSize=10&orderStatusType=DONE"}, function (error, response) {
            console.log('ihg Finish /course/list.do: ', response)
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
                        {
                            item.ORDER_STATUS == 2?<TouchableHighlight style={styles.selectBtn} underlayColor = '#eee' onPress={()=>this._onEnsureCource(item)}>
                                <Text style={styles.sureBtnText}>确认完成</Text>
                            </TouchableHighlight>: <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onLikeCource(item)}>
                                <View style={styles.likeBtn}>
                                    <Image style={styles.likeImg} source={item.ORDER_STATUS == 3?require('../../img/me/icon_unlike.png'):require('../../img/me/icon_like.png')}/>
                                    <Text style={styles.likeBtnText}>好评</Text>
                                </View>
                            </TouchableHighlight>
                        }
                    </View>
                    <ListLine style ={styles.listItemLine}/>
                </View>
            </TouchableHighlight>
        );

    };

    _onLikeCource(item){
        let context = this;
        if(item.ORDER_STATUS == 3){
            let url = "/course/evaluate.do?orderId=" + item.ORDER_ID;
            context.state.cources[item.key].ORDER_STATUS = 4;
            var videos = [];
            for (let i = 0; i < context.state.cources.length; i++) {
                var cource = context.state.cources[i];
                videos.push(cource);
            }
            context.setState({
                cources: videos
            });
            ReactModule.fetch("get", {api: url}, function (error, response) {
                console.log('ihg ' + url, response)
                if (error) {

                } else {

                }
            });
        }
    }
    _onEnsureCource(item){
        let context = this;
        if(item.ORDER_STATUS == 3){
            let url = "/course/confirmEnd.do?orderId=" + item.ORDER_ID;
            context.state.cources[item.key].ORDER_STATUS = 3;
            context.setState({
                videos: context.state.cources
            });
            ReactModule.fetch("get", {api: url}, function (error, response) {
                console.log('ihg ' + url, response)
                if (error) {

                } else {

                }
            });
        }
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
    likeBtn: {
        flexDirection: 'row',
        justifyContent:'center',
        alignItems: 'center',
        paddingLeft: 10,
        paddingRight: 10,
        marginTop: 10,
        marginRight: 10,
        height: 30,
    },

    likeImg: {
        width: 15,
        height: 15
    },
    sureBtnText: {
        color: '#fff',
        fontSize: 16
    },
    likeBtnText: {
        marginLeft: 5,
        color: '#666',
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
        marginTop: 8,
        color: '#999'
    },
    listItemLine: {
        position:'absolute',
        bottom: 0
    }
});

export default FinishedView;