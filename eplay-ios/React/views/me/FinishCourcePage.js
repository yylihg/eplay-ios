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
    NativeModules,
    AlertIOS,
    ActionSheetIOS
} from 'react-native'
var ReactModule = NativeModules.ReactModule;
var findNodeHandle = require('findNodeHandle');
import HeadViewWithLeftBtn from '../common/HeadViewWithLeftBtn';

var timeType = 0;

export default class FinishCourcePage extends Component {

    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            startTime: '',
            endTime: ''
        }
    }


    componentWillReceiveProps(){
        let context = this;
        if (this.props.viewControllerState == "resume" ){
            ReactModule.getItem("newTime", function (result) {
                if (result && result.value == "true"){
                    ReactModule.setItem("newTime", "false");
                    ReactModule.getItem("selectTime", function (result) {
                        if (result && result.value){
                            if (timeType == 0){
                                context.setState({
                                    startTime: result.value
                                })
                            }else {
                                context.setState({
                                    endTime: result.value
                                })
                            }
                        }
                    })
                }
            })
        }
    }

    _selectTime = function (type) {
        timeType = type;
        ReactModule.pushReactViewController(findNodeHandle(this), "SelectDateTimePage", {mode: "datetime"});
    }

    _modifyCourceTime = function () {
        if (this.props.orderId && this.state.startTime && this.state.endTime){
            var context = this;
            ReactModule.fetch("get", {api: "/course/endCourse.do?orderId=" + this.props.orderId
            + "&startTime=" + this.state.startTime+ "&endTime=" + this.state.endTime}, function (error, response) {
                console.log('ihg /course/orderTime.do', response)
                if (error) {
                } else {
                    ReactModule.podViewController(findNodeHandle(context));
                }
            });
        }
    }


    render() {
        let context = this;
        return (
            <View>
                <HeadViewWithLeftBtn title = "线下上课完成"></HeadViewWithLeftBtn>
                <ScrollView >
                    <View style={styles.btnLine}></View>
                    <TouchableHighlight underlayColor = '#eee' onPress={()=>this._selectTime(0)}>
                        <View style={styles.btnStyle}>
                            <Text style={styles.btnText}>{this.state.startTime?this.state.startTime:"请选择开始时间"}</Text>
                            <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                        </View>
                    </TouchableHighlight>

                    <View style={styles.btnLine}></View>
                    <TouchableHighlight underlayColor = '#eee' onPress={()=>this._selectTime(1)}>
                        <View style={styles.btnStyle}>
                            <Text style={styles.btnText}>{this.state.endTime?this.state.endTime:"请选择结束时间"}</Text>
                            <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                        </View>
                    </TouchableHighlight>

                    <View style={styles.btnLine}></View>


                    <TouchableHighlight underlayColor = '#eee' style={styles.updateBtn} onPress={()=>this._modifyCourceTime()}>
                        <Text style={styles.updateBtnText}>完成</Text>
                    </TouchableHighlight>
                </ScrollView>

            </View>
        );
    }
}

const styles = StyleSheet.create({
    updateBtnText:{
        fontSize:14,
        color: '#fff',
        marginLeft: 10
    },
    updateBtn:{
        marginTop:40,
        height: 34,
        marginLeft: 20,
        marginRight:20,
        borderRadius: 10,
        backgroundColor: '#69c2ff',
        borderColor: "#999",
        alignItems:'center',
        justifyContent: 'center'
    },
    headerView:{
        backgroundColor : '#0168ae',
        height: 60,
        justifyContent: 'center',
        alignItems: 'center'
    },
    headerViewTitle:{
        marginTop:10,
        fontSize: 18,
        color: "#fff"
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
    },
    headContainer:{
        height: 160,
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
        width: 10,
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
    },
    dataPickerDialog: {
        position: "absolute",
        top: 100,
        bottom: -70,
        left: 0,
        right: 0,
        backgroundColor: "#fff",
        // opacity: 0.2,
        justifyContent: 'center',
        alignItems: 'center'
    }
});

