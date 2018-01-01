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
import HeadViewWithLeftBtn from '../common/HeadViewWithLeftBtn';
import screen from '../../constants/screen';



export default class IntegralPage extends Component {

    _promote = (index) => {
        switch (index){
            case 1:
                break;
            case 2:
                break;
            default:
                break;
        }
    }

    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
    }

    render() {
        return (
            <View>
                <HeadViewWithLeftBtn title = "积分等级"></HeadViewWithLeftBtn>
                <View style={styles.headContainer}>
                    <Text style={styles.myIntegralText}>我的积分</Text>
                    <Text style={styles.integralText}>{this.props.points}</Text>
                    <Text style={styles.integralLevelText}>初级老鸟</Text>
                </View>
                <TouchableHighlight underlayColor = '#eee' onPress={()=>this._promote(1)}>
                    <View style={styles.btnStyle}>
                        <Image style={styles.btnImg} source={require('../../img/me/icon_me_middle.png')} />
                        <Text style={styles.btnText}>晋升中级老鸟</Text>
                        <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                    </View>
                </TouchableHighlight>
                <View style={styles.btnLine}></View>
                <TouchableHighlight underlayColor = '#eee' onPress={()=>this._promote(2)}>
                    <View style={styles.btnStyle}>
                        <Image style={styles.btnImg} source={require('../../img/me/icon_me_high.png')} />
                        <Text style={styles.btnText}>晋升高级老鸟</Text>
                        <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                    </View>
                </TouchableHighlight>
                <View style={styles.btnLine}></View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    headContainer:{
        height: 170,
        alignItems: 'center',
        backgroundColor: '#005d9d'
    },
    myIntegralText: {
        marginTop: 20,
        color: '#fff',
        fontSize: 14
    },
    integralText: {
        marginTop: 5,
        color: '#fff',
        fontSize: 80
    },
    integralLevelText: {
        marginTop: 5,
        width: screen.width,
        textAlign: 'right',
        marginRight: 40,
        color: '#fff',
        fontSize: 14
    },
    iconImg:{
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
    }
});

