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
    Alert,
    TouchableHighlight,
    NativeModules
} from 'react-native'
var ReactModule = NativeModules.ReactModule;
var findNodeHandle = require('findNodeHandle');
import HeadView from '../common/HeadView';
import UnLoginView from '../common/UnLoginView';
import RequestUtils from '../../utils/RequestUtils';
import UserUtils from '../../utils/UserUtils'

export default class IndividualView extends Component {
    componentWillReceiveProps(){
        if (this.props.viewControllerState == "resume" ){
            this._initView();
        }
    }
    componentDidMount() {
        this._initView();
    }
    
    _initView = function () {
        var context = this;
        UserUtils.getUser(function (result) {
            if (result.userToken && !context.setState.isLogin){
                context._getUserInfo();
                context.setState({
                    isLogin:true,
                    userType:result.roleId == "4"?'teacher':'student'
                })
            }else if(!result.userToken){
                context.setState({
                    isLogin:false
                })
            }
        })
    }


    _getUserInfo = () => {
        var context = this;
        RequestUtils.fetch(this, "get",{api:"/myinfo/info.do"},function (response) {
            console.log('ihg /myinfo/info.do: ', response)
            // alert(JSON.stringify(response))
            if (response.code != 0){
            }else {
                ReactModule.setItem("userInfo", JSON.stringify(response.data.data ||{}));
                context.setState({
                    userInfo:response.data.data ||{}
                })
            }
        });


    }

    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            userType:"student",
            isLogin: true,
            userInfo: {}
        }
    }


    _onPressButton(id) {
        switch (id){
            case 1:
                ReactModule.pushReactViewController(findNodeHandle(this), "CollectListPage", {});
                break
            case 2:
                ReactModule.pushReactViewController(findNodeHandle(this), "BoughtVideoListPage", {});
                break
            case 3:
                ReactModule.pushReactViewController(findNodeHandle(this), "CourcesListPage", {userType: this.state.userType});
                break
            case 4:
                ReactModule.pushReactViewController(findNodeHandle(this), "IndividualCenterPage", {});
                break
            case 5:
                this._logout();
                break;
            case 6:
                ReactModule.pushReactViewController(findNodeHandle(this), "IntegralPage", {points: this.state.userInfo.LEVEL_POINTS});
                break;
            case 7:
                ReactModule.pushReactViewController(findNodeHandle(this), "IntegralPage", {});
                break;
            case 8:
                ReactModule.pushReactViewController(findNodeHandle(this), "TeacherGroupView", {});
                break;
            case 9:
                ReactModule.pushReactViewController(findNodeHandle(this), "TeacherTeamListPage", {});
                break;
            case 10:
                ReactModule.pushReactViewController(findNodeHandle(this), "AboutPage", {});
                break;
            case 11:
                ReactModule.pushReactViewController(findNodeHandle(this), "StudentGroupListPage", {});
                break;
            case 12:
                ReactModule.pushReactViewController(findNodeHandle(this), "StudentTeamListView", {});
                break;
            default:
                break;
        }
    }

    _logout(){
        var context = this;
       Alert.alert(
            '您真的要退出么？',
            "",
            [
                {text: '取消', onPress: () => {}},
                {text: '确定', onPress: () => {
                    ReactModule.loginOut();
                    context._initView();
                }},
            ]
        )

    }

    render() {
        return (
            <View style={{flex:1}}>
                <HeadView title="个人"></HeadView>
                {this.state.isLogin?
                    <ScrollView >
                        <View style={styles.headContainer}>
                            <Image style={styles.iconImg} source={this.state.userInfo.PHOTO0?{uri:this.state.userInfo.PHOTO0}:require('../../img/me/icon_me_man.png')} />
                        </View>
                        <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(this.state.userType == "teacher"?6:1)}>
                            <View style={styles.btnStyle}>
                                <Image style={styles.btnImg} source={this.state.userType == "teacher"?
                                    require('../../img/me/icon_me_integral.png'):require('../../img/me/icon_me_collect.png')} />
                                <Text style={styles.btnText}>{this.state.userType == "teacher"?"积分等级":"我的收藏"}</Text>
                                <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                            </View>
                        </TouchableHighlight>
                        {/*<View style={styles.btnLine}></View>*/}
                        {/*{*/}
                            {/*this.state.userType == "teacher"?*/}
                                {/*<TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(8)}>*/}
                                    {/*<View style={styles.btnStyle}>*/}
                                        {/*<Image style={styles.btnImg} source={require('../../img/me/icon_me_group.png')} />*/}
                                        {/*<Text style={styles.btnText}>发布的团购课程</Text>*/}
                                        {/*<Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />*/}
                                    {/*</View>*/}
                                {/*</TouchableHighlight>:<TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(11)}>*/}
                                {/*<View style={styles.btnStyle}>*/}
                                    {/*<Image style={styles.btnImg} source={require('../../img/me/icon_me_group.png')} />*/}
                                    {/*<Text style={styles.btnText}>我的团购课程</Text>*/}
                                    {/*<Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />*/}
                                {/*</View>*/}
                            {/*</TouchableHighlight>*/}
                        {/*}*/}
                        {/*<View style={styles.btnLine}></View>*/}
                        {/*{*/}
                            {/*this.state.userType == "teacher"?*/}
                                {/*<TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(9)}>*/}
                                    {/*<View style={styles.btnStyle}>*/}
                                        {/*<Image style={styles.btnImg} source={require('../../img/me/icon_me_team.png')} />*/}
                                        {/*<Text style={styles.btnText}>发布的小组课</Text>*/}
                                        {/*<Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />*/}
                                    {/*</View>*/}
                                {/*</TouchableHighlight>:<TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(12)}>*/}
                                {/*<View style={styles.btnStyle}>*/}
                                    {/*<Image style={styles.btnImg} source={require('../../img/me/icon_me_team.png')} />*/}
                                    {/*<Text style={styles.btnText}>我的小组课</Text>*/}
                                    {/*<Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />*/}
                                {/*</View>*/}
                            {/*</TouchableHighlight>*/}
                        {/*}*/}
                        {
                            this.state.userType == "teacher"?<View></View>:
                                <View style={styles.btnLine}></View>
                        }
                        {
                            this.state.userType == "teacher"?<View></View>:
                                <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(2)}>
                                    <View style={styles.btnStyle}>
                                        <Image style={styles.btnImg} source={require('../../img/me/icon_me_video.png')} />
                                        <Text style={styles.btnText}>我的视频</Text>
                                        <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                                    </View>
                                </TouchableHighlight>
                        }
                        <View style={styles.btnLine}></View>
                        <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(3)}>
                            <View style={styles.btnStyle}>
                                <Image style={styles.btnImg} source={require('../../img/me/icon_me_cources.png')} />
                                <Text style={styles.btnText}>课程列表</Text>
                                <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                            </View>
                        </TouchableHighlight>
                        <View style={styles.btnLine}></View>
                        <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(4)}>
                            <View style={styles.btnStyle}>
                                <Image style={styles.btnImg} source={require('../../img/me/icon_me_info.png')} />
                                <Text style={styles.btnText}>个人信息设置</Text>
                                <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                            </View>
                        </TouchableHighlight>
                        <View style={styles.btnLine}></View>
                        <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(10)}>
                            <View style={styles.btnStyle}>
                                <Image style={styles.btnImg} source={require('../../img/me/icon_me_about.png')} />
                                <Text style={styles.btnText}>关于我们</Text>
                                <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                            </View>
                        </TouchableHighlight>
                        <View style={styles.btnLine}></View>
                        <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(5)}>
                            <View style={styles.btnStyle}>
                                <Image style={styles.btnImg} source={require('../../img/me/icon_me_logout.png')} />
                                <Text style={styles.btnText}>退出登录</Text>
                            </View>
                        </TouchableHighlight>
                        <View style={styles.btnLine}></View>
                    </ScrollView>
                    :<UnLoginView></UnLoginView>}
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1
    },
    headContainer:{
        height: 150,
        justifyContent: 'center',
        alignItems: 'center'
    },
    iconImg:{
        borderRadius: 50,
        height:100,
        width:100
    },
    btnImg:{
        height:16,
        width:16,
        marginLeft: 20
    },
    rightArrow: {
        width: 8,
        height:10,
        marginRight: 20
    },
    btnText:{
        flex: 1,
        fontSize:14,
        color: '#666',
        marginLeft: 10
    },
    btnLine:{
        backgroundColor: '#ccc',
        height: 0.5,
        marginLeft: 10,
        marginRight: 10
    },
    btnStyle:{
        flexDirection: 'row',
        height: 48,
        alignItems:'center'
    },
    btnLoginOut:{
        marginTop:100,
        borderWidth:1,
        height: 48,
        marginLeft: 20,
        marginRight:20,
        borderRadius: 10,
        borderColor: "#999",
        alignItems:'center',
        justifyContent: 'center'
    }
});

