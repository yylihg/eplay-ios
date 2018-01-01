/**
 * Created by yanlin.yyl.
 */
'use strict';

import  {
    View,
    Text,
    Image,
    StyleSheet,
    TouchableHighlight,
    NativeModules,
    DatePickerIOS
} from 'react-native';

import React, {Component} from 'react';
var ReactModule = NativeModules.ReactModule;
var findNodeHandle = require('findNodeHandle');
export default class SelectDateTimePage extends Component {


    getTime =  function(time) {
        if (!time){
            return ""
        }
        function add0(dateValue) {
            return dateValue < 10 ? '0' + dateValue : dateValue;
        }
        let y = time.getFullYear();
        let m = time.getMonth() + 1;
        let d = time.getDate();

        let h = time.getHours();
        let mm = time.getMinutes();
        let ss = time.getSeconds();
        return y + '-' + add0(m) + '-' + add0(d) + ' ' + add0(h)  +':' + add0(mm)  +':' + add0(ss);
    }

    _back = function () {
        ReactModule.podViewController(findNodeHandle(this));
    }

    _save = function () {
        ReactModule.setItem("selectTime", this.getTime(this.state.date))
        ReactModule.setItem("newTime", "true");
        this._back();
    }
    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            date: new Date(),
            datePickMode: this.props.mode
        }
    }
    render() {
        let context = this;
        return (
            <View>
                <View style={styles.headerView}>
                    <TouchableHighlight style={styles.backBtn} underlayColor = '#eee' onPress={()=>this._back()}>
                        <Image style={styles.backImg} source={require('../../img/icon_back.png')} />
                    </TouchableHighlight>
                    <Text style={styles.headerViewTitle}>选择日期</Text>
                    <TouchableHighlight style={styles.backBtn} underlayColor = '#eee' onPress={()=>this._save()}>
                        <Text style={styles.saveBtn}>确定</Text>
                    </TouchableHighlight>
                </View>
                <DatePickerIOS
                    date={context.state.date}
                    mode={context.state.datePickMode?context.state.datePickMode:"date"}
                    onDateChange={function (date) {
                        context.setState({
                            date: date
                        })
                    }}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    headerView:{
        paddingTop: 20,
        backgroundColor : '#0168ae',
        height: 70,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    headerViewTitle:{
        flex: 1,
        fontSize: 18,
        textAlign: 'center',
        color: "#fff"
    },
    backBtn:{
        height:40,
        width:40,
        justifyContent:'center',
        alignItems: 'center'
    },
    saveBtn:{
        marginRight: 10,
        color: "#fff",
        fontSize: 14
    },
    backImg: {
        height: 15,
        width:15
    }
});