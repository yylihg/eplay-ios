/**
 * Created by yanlin.yyl.
 */
'use strict';

import  {
    AppRegistry,
    View,
    StyleSheet
} from 'react-native';

import React, {Component} from 'react';
import ScrollableTabView from 'react-native-scrollable-tab-view';

import HeadView from '../common/HeadView';
import SeeDemoVideoView from './SeeDemoVideoView';
import SeeTeacherDemoVideoView from './SeeTeacherDemoVideoView';
import SeeTeacherFormalVideoView from './SeeTeacherFormalVideoView';
import SeeFormalVideoView from './SeeFormalVideoView';
import CustomTabBar from '../common/CustomTabBar';
import UserUtils from '../../utils/UserUtils'

export default class SeeView extends Component {

    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            user: {
                userId: "",
                userType:"student",
                isLogin: false
            }
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
                    userType:result.roleId == "4"?'student':'teacher'
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
                <HeadView title="视频列表"></HeadView>
                {this.state.user.userType == "teacher"?
                    <ScrollableTabView renderTabBar={() => <CustomTabBar someProp={'here'} />}>
                        <SeeTeacherDemoVideoView tabLabel="公益教学"></SeeTeacherDemoVideoView>
                        <SeeTeacherFormalVideoView tabLabel="专业教学"></SeeTeacherFormalVideoView>
                    </ScrollableTabView>
                    :<ScrollableTabView renderTabBar={() => <CustomTabBar someProp={'here'} />}>
                        <SeeDemoVideoView isLogin={this.state.isLogin} tabLabel="公益教学"></SeeDemoVideoView>
                        <SeeFormalVideoView isLogin={this.state.isLogin}  tabLabel="专业教学"></SeeFormalVideoView>
                    </ScrollableTabView> }

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
AppRegistry.registerComponent('SeeView', () => SeeView);
