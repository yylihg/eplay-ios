/**
 * Created by yanlin.yyl.
 */
'use strict';

import  {
    View,
    Text,
    StyleSheet,
    TouchableHighlight,
    NativeModules
} from 'react-native';

import React, {Component} from 'react';
var ReactModule = NativeModules.ReactModule;
var findNodeHandle = require('findNodeHandle');

class UnLoginView extends Component {
    _doLogin = function () {
        ReactModule.pushLoginController(findNodeHandle(this), function (e) {
                // alert(JSON.stringify(e))
            })
    }

    render() {
        return (
            <View style={styles.containerStyle}>
                <Text style={styles.tips}>您还未登陆哦～</Text>
                <TouchableHighlight style={styles.loginBtn} underlayColor='#eee' onPress={() => this._doLogin()}>
                    <Text style={styles.loginBtnText}>点我登陆</Text>
                </TouchableHighlight>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    containerStyle: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center'
    },
    tips: {
        fontSize: 14,
        color: "#666"
    },
    loginBtn: {
        backgroundColor: '#0168ae',
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 5,
        marginTop: 10,
        marginLeft: 10,
        marginRight: 10,
        width: 100,
        height: 40,
    },
    loginBtnText: {
        color: '#fff',
        fontSize: 14
    },
});

export default UnLoginView;