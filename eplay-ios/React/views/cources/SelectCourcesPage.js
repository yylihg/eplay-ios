/**
 * Created by yanlin.yyl.
 */
'use strict';

import  {
    View,
    StyleSheet
} from 'react-native';

import React, {Component} from 'react';
import ScrollableTabView, { DefaultTabBar } from 'react-native-scrollable-tab-view';

import HeadView from '../common/HeadView';
import TeacherListView from './TeacherListView';

import GroupBuyListView from './GroupBuyListView';
import TeacherFinishedView from './TeacherFinishedView';
import TeacherBookedView from './TeacherBookedView';
import CustomTabBar from '../common/CustomTabBar';
import UserUtils from '../../utils/UserUtils'
export default class SelectCourcesPage extends Component {
    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            userType:"student",
            isLogin: false
        }
    }

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

    render() {
        return (
            <View style={{flex:1}}>
                <HeadView title="约课"></HeadView>
                {/*<ScrollableTabView renderTabBar={() => <CustomTabBar someProp={'here'} />}>*/}
                    <TeacherListView isLogin={this.state.isLogin} tabLabel="教师资源"></TeacherListView>
                    {/*<GroupBuyListView isLogin={this.state.isLogin} tabLabel="团购课程"></GroupBuyListView>*/}
                {/*</ScrollableTabView>*/}
            </View>
        );
    }
}

const styles = StyleSheet.create({
    tabBarText: {
        fontSize: 14,
        marginTop: 5,
    },
    tabBarUnderline: {
        backgroundColor: '#FE566D'
    }
});
