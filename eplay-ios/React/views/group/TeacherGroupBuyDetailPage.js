/**
 * Created by yanlin.yyl.
 */
'use strict';

import  {
    View,
    Text,
    Image,
    TouchableHighlight,
    NativeModules,
    StyleSheet,
    ScrollView
} from 'react-native';

import screen from '../../constants/screen';
import HeadViewWithLeftBtn from '../common/HeadViewWithLeftBtn';
import React, {Component} from 'react';
var ReactModule = NativeModules.ReactModule;
var ReactIMModule = NativeModules.ReactIMModule;
var findNodeHandle = require('findNodeHandle');
import UserUtils from '../../utils/UserUtils'
import ListLine from '../common/ListLine'

export default class TeacherGroupBuyDetailPage extends Component {
    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            teacher: {},
            userType: "student",
            isLogin: false
        }
    }

    componentWillReceiveProps(){
        if (this.props.viewControllerState == "resume" ){
            this._initView();
        }
    }

    _initView = function () {
        var context = this;
        UserUtils.getUser(function (result) {
            if (result.userToken && !context.setState.isLogin){
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


    componentDidMount() {
        this._initView();
    }


    _startCourse(){
        ReactModule.fetch("get", {api: "/groupLive/beginClassNotice.do?orderId=" + this.props.ORDER_ID}, function (error, response) {
            console.log('ihg /groupLive/beginClassNotice.do', response)
            if (error) {
            } else {
            }
        });
        ReactModule.fetch("get", {api: "/groupLive/begin.do?orderId=" + this.props.ORDER_ID}, function (error, response) {
            console.log('/groupLive/begin.do', response)
            if (error) {
            } else {
                var liveInfo = response.data?response.data.data:{};
                if (liveInfo && liveInfo.ROOMID && liveInfo.PUSH_URL){
                    ReactIMModule.pushLiveController(liveInfo.ROOMID, liveInfo.PUSH_URL);
                }
            }
        });
     }

    _stopCourse(){
        ReactModule.fetch("get", {api: "/groupLive/endClass.do?orderId=" + this.props.ORDER_ID}, function (error, response) {
            console.log('ihg /groupLive/endClass.do', response)
            if (error) {
            } else {
                alert("success!")
            }
        });

     }

    render() {
        return (
            <View>
                <HeadViewWithLeftBtn title = {this.props.ORDER_NAME}></HeadViewWithLeftBtn>
                <ScrollView>
                    <Image style={styles.imageType} source={{uri: this.props.TEACHER_IMG_URL}}></Image>
                    <View style={styles.bodyContainer}>
                        <Text style={styles.rowTitle}>{this.props.ORDER_NAME}</Text>
                        <ListLine></ListLine>
                        <Text style={styles.rowDes}>课程类型：{this.props.CLASS_TYPE_NAME}</Text>
                        {/*<Text style={styles.rowDes}>团购价格：{this.props.CLASS_PRICE}</Text>*/}
                        {/*<Text style={styles.rowDes}>课程总价：{this.props.TOTAL_PRICE}</Text>*/}
                        {/*<Text style={styles.rowDes}>已团购人数：{this.props.CURRENT_SIZE}</Text>*/}
                        <Text style={styles.rowDes}>上传人：{this.props.NAME}</Text>
                    </View>
                    <TouchableHighlight style={styles.buttonStyle} underlayColor = '#eee' onPress={()=>this._startCourse()}>
                        <Text style={styles.buttonText}>上课</Text>
                    </TouchableHighlight>
                    <TouchableHighlight style={styles.buttonStyle} underlayColor = '#eee' onPress={()=>this._stopCourse()}>
                        <Text style={styles.buttonText}>结束本次课程</Text>
                    </TouchableHighlight>
                </ScrollView>

            </View>
        );
    }
}

const styles = StyleSheet.create({
    bodyContainer: {
        marginTop:5,
        marginLeft: 5,
        marginRight: 5,
        backgroundColor:"#eee",
        borderRadius:5,
        paddingBottom: 10

    },
    imageType: {

        height: 150
    },
    rowContainer: {
        marginTop: 8,
        flexDirection:'row'
    },
    rowTitle: {
        marginLeft: 5,
        marginTop: 10,
        marginBottom: 10,
        color: '#666',
        fontSize: 14
    },
    rowDes: {
        marginLeft: 5,
        marginTop: 10,
        color: '#666',
        fontSize: 12
    },
    buttonStyle: {
        borderRadius: 5,
        alignItems:'center',
        justifyContent:'center',
        width:screen.width - 20,
        marginLeft: 10,
        marginTop: 20,
        height:32,
        backgroundColor: '#0168ae'
    },
    buttonText: {
        fontSize: 14,
        color: '#fff'
    }

});