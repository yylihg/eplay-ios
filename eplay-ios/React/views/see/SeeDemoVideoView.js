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
let curKey= '';

var findNodeHandle = require('findNodeHandle');
import Toast, {DURATION} from 'react-native-easy-toast'
class SeeDemoVideoView extends Component {

    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            videos: []
        }
    }
    componentDidMount() {
        this._getVideoList(currentPage);
    }
    _getVideoList = function (page, keyWord) {
        var context = this;
        var url = '';
        if (curKey){
            keyWord = curKey;
        }
        if (keyWord){
            url = "/freeVideo/list.do?start="+page*10+"&pageSize=10&keywords=" + keyWord;
        }else {
            url = "/freeVideo/list.do?start="+page*10+"&pageSize=10";
        }

        ReactModule.fetch("get",{api:url},function (error, response) {
            console.log('ihg /freeVideo/list.do: ', response)
            if (error){
                currentPage -=1;
            }else {
                totalCount = response.data.total;
                currentIndex = context.state.videos.length;
                let videoTemp = response.data.list || [];
                let videoList = currentPage == 0? []:context.state.videos;
                for (let i = 0; i < videoTemp.length; i++){
                    videoTemp[i].key = currentIndex + "";
                    currentIndex += 1;
                    videoList.push(videoTemp[i]);
                }
                context.setState({
                    videos: videoList
                });
            }
        });
    }


    render() {
        return (
            <View>
                <SearchView doSearch = {(key) => this.doSearch(key)}/>
                <ListLine style ={styles.listItemLine}/>
                <AnimatedFlatList
                    style = {{marginBottom: 100}}
                    data={this.state.videos}
                    renderItem={this._renderItemComponent}
                    onEndReached={this._onEndReached}
                    onRefresh={this._onRefresh}
                    refreshing={false}
                />
                <Toast ref="toast"/>
            </View>
        );
    }

    _onItemPress(item) {
        ReactModule.pushVideoViewController(findNodeHandle(this), "/member/freeVideoWatch/getVideoUrl.do?videoId="+ item.VIDEO_ID, item.VIDEO_NAME);
    }

    _renderItemComponent = ({item, separators}) => {
        return (
            <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onItemPress(item)}>
                <View>
                    <View style={styles.listItemContainer}>
                        <Image style={styles.listItemImage} source={{uri: item.PRIVIEW_IMG_URL}}/>
                        <View style={styles.listItemText}>
                            <Text numberOfLines={1} style={styles.listItemTitle}>{item.VIDEO_NAME}</Text>
                            <Text numberOfLines={2} style={styles.listItemDes}>{item.VIDEO_REMARK}</Text>
                        </View>
                        <TouchableHighlight style={styles.collectBtn} underlayColor = '#eee' onPress={()=>this._collectVideo(item)}>
                            <Image style={styles.collectImg} source={item.IS_COLLECT?require('../../img/see/icon_see_collected.png'):require('../../img/see/icon_see_collect.png')}/>
                        </TouchableHighlight>
                        <TouchableHighlight style={styles.selectBtn} underlayColor = '#eee' onPress={()=>this._onSelectCource(item)}>
                            <View >
                                <Text style={styles.selectBtnText}>约课</Text>
                            </View>
                        </TouchableHighlight>
                    </View>
                    <ListLine style ={styles.listItemLine}/>
                </View>
            </TouchableHighlight>
        );

    };

    _collectVideo = (item) => {
        if (!this.props.isLogin){
            ReactModule.pushLoginController(findNodeHandle(this), function (e) {
                // alert(JSON.stringify(e))
            })
            return;
        }
        var context = this;
        if (item.IS_COLLECT){
            return;
        }
        context.state.videos[item.key].IS_COLLECT = true;
        context.setState({
            videos: context.state.videos
        });
        ReactModule.fetch("get",{api:"/member/freeVideoCollect/collect.do?videoId="+ item.VIDEO_ID},function (error, response) {
            console.log('ihg /member/freeVideoCollect/collect.do', response)
            if (error){
            }else {
                if (response.code == "0"){
                    context.refs.toast.show('收藏成功！');
                }
            }
        });
    }

    _onSelectCource(item){
        if (!this.props.isLogin){
            ReactModule.pushLoginController(findNodeHandle(this), function (e) {
                // alert(JSON.stringify(e))
            })
            return;
        }
        ReactModule.pushReactViewController(findNodeHandle(this), "BookPage", {id: item.UPLOAD_USER_ID});
    }

    _onEndReached = () => {
        if (this.state.videos.length < 9) {
            return;
        }
        if (this.state.videos.length < totalCount){
            currentPage += 1;
            this._getVideoList(currentPage);
        }
    };
    _onRefresh = () => {
        currentPage = 0;
        curKey = '';
        this._getVideoList(currentPage);
    }


    doSearch = (key) => {
        currentPage = 0;
        curKey = key;
        this._getVideoList(currentPage, key);
    }
}

const styles = StyleSheet.create({
    collectBtn: {
        justifyContent:'center',
        alignItems: 'center',
        width: 20,
        marginTop: 15,
        marginRight: 5,
        height: 20,
    },
    collectImg: {
        width: 15,
        height: 15
    },
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

export default SeeDemoVideoView;