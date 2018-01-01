/**
 * Created by yanlin.yyl on 2017/4/4.
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    ScrollView,
    TouchableHighlight,
    TextInput,
    Alert,
    NativeModules,
    NativeEventEmitter
} from 'react-native'

import GridView from './GridView';
import HotTeacherList from './HotTeacherList';
import HotVideoList from './HotVideoList';
import Banner from'./Banner';

var ReactModule = NativeModules.ReactModule;
import RequestUtils from '../../utils/RequestUtils';
var findNodeHandle = require('findNodeHandle');


export default class HomeView extends Component {

    _onPressButton(id) {
        console.log('ihg',id +  "You tapped the button!");
    }
    //点击事件
    _onMenuClick(title, tag) {
        Alert.alert('提示', '你点击了:' + title + " Tag:" + tag);
    }

    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            instruments: [
                { title: '吉他', image: require('../../img/Home/icon_guitar.png') , code: "GUITAR"},
                { title: '贝斯', image: require('../../img/Home/icon_bass.png') , code: "BASS" },
                { title: '架子鼓', image: require('../../img/Home/icon_drum.png')  , code: "DRUM"},
                { title: '钢琴', image: require('../../img/Home/icon_piano.png') , code: "PIANO" }
            ],
            teachers: [],
            videos: []
        }
    }

    componentDidMount() {
        this._getTop10Teacher();
        this._getTop10Video();
    }

    _getTop10Teacher = function () {
        var context = this;
        RequestUtils.fetch(this, "get",{api:"/teacher/findTop10.do"},function (response) {
            console.log("ihg top10 teacher:", response);
            let teacherTemp = response.data.list || [];
            let teacherList = context.state.teachers;
            for (let i = 0; i < teacherTemp.length; i++){
                teacherTemp[i].key = i + "";
                teacherList.push(teacherTemp[i]);
            }
            context.setState({
                teachers: teacherList
            });
        });
    }
    _getTop10Video = function () {
        var context = this;
        RequestUtils.fetch(this, "get",{api:"/freeVideo/findTop10.do"},function (response) {
            // alert('freeVideo:' + JSON.stringify(response));
            console.log("ihg top10 video:", response);
            let videosTemp = response.data.list;
            let videoList = context.state.videos;
            for (let i = 0; i < videosTemp.length; i++){
                videosTemp[i].key = i + "";
                videoList.push(videosTemp[i]);
            }
            context.setState({
                videos: videoList
            });
        });
    }

    _getMoreTeacher = function () {
        ReactModule.pushReactViewController(findNodeHandle(this), "TeacherListPage", {api: "/teacher/list.do?"});
    }
    _getMoreVideo = function () {
        ReactModule.pushReactViewController(findNodeHandle(this), "VideoListPage", {api: "/freeVideo/list.do?"});
    }

    render() {
        return (
        <View style={styles.container}>
            <ScrollView contentContainerStyle={styles.bodyContainer}>
                <View style={styles.viewPager}>
                    <Banner></Banner>
                </View>
                <GridView datas={this.state.instruments} onGridSelected={(index) => this.onGridSelected(index)}/>
                <View style={styles.hotTeacher}>
                    <Text style={styles.hotTitle}>热门推荐</Text>
                    <TouchableHighlight underlayColor = '#fff' onPress={()=>this._getMoreTeacher()}>
                        <Text  style={styles.hotMore}>更多></Text>
                    </TouchableHighlight>
                </View>
                <HotTeacherList datas={this.state.teachers} onItemSelected={(index) => this.onTeacherItemSelected(index)}/>
                <View style={styles.hotTeacher}>
                    <Text style={styles.hotTitle}>热门视频</Text>
                    <TouchableHighlight underlayColor = '#fff' onPress={()=>this._getMoreVideo()}>
                        <Text  style={styles.hotMore}>更多></Text>
                    </TouchableHighlight>
                </View>
                <HotVideoList datas={this.state.videos} onItemSelected={(index) => this.onVideoItemSelected(index)}/>
            </ScrollView>
            <View style={styles.searchBar }>
                {/*<TouchableHighlight style={{overflow:'hidden'}} underlayColor = '#eee' onPress={()=>this._onPressButton(1)}>*/}
                {/*<Text style={styles.searchBtn}>杭州</Text>*/}
                {/*</TouchableHighlight>*/}
                <TextInput placeholder="请输入关键字" placeholderTextColor= '#fff'
                           returnKeyType="search"
                           style={styles.searchInput}
                           onSubmitEditing= {(event) => this._doSearch(event.nativeEvent.text)}/>
                <Image style={styles.searchImg} source={require('../../img/Home/icon_search.png')} />
            </View>
        </View>
        );
    }

    _doSearch(text){
        if (text){
            ReactModule.pushReactViewController(findNodeHandle(this), "TeacherListPage", {api: "/teacher/list.do?keywords="+encodeURI(text) + "&"});
        }
    }

    //noinspection JSAnnotator
    onGridSelected(index: number) {
        let instrument = this.state.instruments[index]
        ReactModule.pushReactViewController(findNodeHandle(this), "TeacherListPage", {api: "/teacher/list.do?type="+instrument.code + "&"});
    }
    //noinspection JSAnnotator
    onTeacherItemSelected(index: number) {
        ReactModule.pushReactViewController(findNodeHandle(this), "TeacherDetailPage", {id: this.state.teachers[index].USER_ID});
    }
    //noinspection JSAnnotator
    onVideoItemSelected(index: number) {

        ReactModule.pushVideoViewController(findNodeHandle(this), "/member/freeVideoWatch/getVideoUrl.do?videoId="+ this.state.videos[index].VIDEO_ID, this.state.videos[index].VIDEO_NAME);
        // Alert.alert('提示', '你点击了:' + JSON.stringify(video));
    }

}

const styles = StyleSheet.create({
    container: {
    },
    bodyContainer:{
        paddingBottom: 30,
        marginTop: -20,
    },
    searchBar: {
        flexDirection: 'row',
        backgroundColor: '#eeeeee66',
        position: 'absolute',
        top: 0,
        left:0,
        right: 0,
        marginTop: 20,
        alignItems: 'center',
        height: 48,
    },
    searchBtn: {
        marginRight: 5,
        marginLeft: 5,
        backgroundColor: '#900',
        textAlign: 'center'
    },
    searchInput: {
        paddingLeft:15,
        flex:1,
        height: 36,
        marginLeft: 20,
        marginRight: 20,
        backgroundColor: '#b6b6b699',
        marginTop:6,
        borderRadius: 10,
        fontSize: 14,
        color: '#fff'
    },
    searchImg: {
        position: 'absolute',
        right:30,
        height: 20,
        width:20,
        top: 14
    },
    viewPager: {
        height: 150
    },
    instrumentCell: {
        height: 100,
        width: 100,
    },
    hotTeacher: {
        flexDirection: 'row',
        height:30,
        justifyContent:'center',
        alignItems: 'center',
        backgroundColor: '#eee',
    },
    hotTitle:{
        color: '#666',
        flex:1,
        fontSize: 14,
        marginLeft:20
    },
    hotMore:{
        color: '#666',
        fontSize: 14,
        marginRight: 10
    }
});

