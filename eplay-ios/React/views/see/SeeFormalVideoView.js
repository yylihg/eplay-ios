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


class SeeFormalVideoView extends Component {

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
        if (curKey){
            keyWord = curKey;
        }
        var url = '';
        if (keyWord){
            url = "/officialVideo/list.do?start="+page*10+"&pageSize=10&keywords=" + keyWord;
        }else {
            url = "/officialVideo/list.do?start="+page*10+"&pageSize=10";
        }

        var context = this;
        ReactModule.fetch("get",{api:url},function (error, response) {
            console.log('ihg /officialVideo/list.do: ', response)
            if (response.code != 0){
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
            </View>
        );
    }

    _onItemPress(item) {
        if (!this.props.isLogin){
            ReactModule.pushLoginController(findNodeHandle(this), function (e) {
                // alert(JSON.stringify(e))
            })
            return;
        }
        ReactModule.pushVideoViewController(findNodeHandle(this), "/member/officialVideoBuy/getVideoUrl.do?videoId="+ item.VIDEO_ID, item.VIDEO_NAME);
    }

    _renderItemComponent = ({item, separators}) => {
        return (
            <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onItemPress(item)}>
                <View>
                    <View style={styles.listItemContainer}>
                        <Image style={styles.listItemImage} source={{uri: item.PRIVIEW_IMG_URL}}/>
                        <View style={styles.listItemText}>
                            <Text style={styles.listItemTitle}>{item.VIDEO_NAME}</Text>
                            <Text style={styles.listItemDes}>{item.VIDEO_REMARK}</Text>
                        </View>
                    </View>
                    <ListLine style ={styles.listItemLine}/>
                </View>
            </TouchableHighlight>
        );

    };

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

export default SeeFormalVideoView;