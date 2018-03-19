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
var findNodeHandle = require('findNodeHandle');
import UserUtils from '../../utils/UserUtils'
import ListLine from '../common/ListLine'

export default class TeacherGroupBuyDetailPage extends Component {
    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)

    }




    componentDidMount() {
    }



    render() {
        return (
            <View style={{alignItems: 'center'}}>
                <HeadViewWithLeftBtn title = "关于我们"></HeadViewWithLeftBtn>
                <Image style={styles.imageType} source={require('../../img/me/icon_me_about_logo.png')}></Image>
                <View style={styles.bodyContainer}>
                    <Text style={styles.rowDes}>        艺教兔由厦门帮她科技有限公司音为爱研发团队研发。产品旨在建立专业的音乐教学传播平台，通过PC端以及手机端的应用，提供线上在线学习、线下预约等服务。首先平台入驻教学老师通过经过实名以及资格审核，教学质量具有保障性。同时平台提供多个功能，比如发布视频，学生用户可以通过视频学习，视频都是经过专业录制，保证视频播放的质量以及学习成果；另外提供预约上课模块，即可到门店进行学习，也可在线实时视频教学，对于不在同个区域的学生用户，可以远程进行学习,方便快捷。最后提供有保证的定制乐器的销售，可以在平台购买到定制的乐器。更多功能敬请期待。</Text>
                </View>
                <Text style={{marginTop: 100}}>Copyright@2016-2017 厦门帮她科技有限公司</Text>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    bodyContainer: {
        alignItems: 'center',
        marginTop:5,
        marginLeft: 5,
        marginRight: 5,
        backgroundColor:"#eee",
        borderRadius:5,
        paddingBottom: 10
    },
    imageType: {
        height: 50,
        marginTop: 20,
        marginBottom: 40,
        alignItems:'center',
        justifyContent: 'center'
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
        padding: 5,
        marginLeft: 5,
        marginRight: 5,
        alignItems: 'center',
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