/**
 * Created by yanlin.yyl.
 */
'use strict';

import  {
    View,
    StyleSheet
} from 'react-native';
import React, {Component} from 'react';

import HeadViewWithLeftBtn from '../common/HeadViewWithLeftBtn';
import ScrollableTabView, { DefaultTabBar } from 'react-native-scrollable-tab-view';
import BookedView from '../cources/BookedView';
import FinishedView from '../cources/FinishedView';
import CustomTabBar from '../common/CustomTabBar';
import TeacherBookedView from "../cources/TeacherBookedView";
import TeacherFinishedView from "../cources/TeacherFinishedView";


class CourcesListPage extends Component {
    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            videos: []
        }
    }
    componentDidMount() {
    }

    render() {
        return (
            <View style={{flex:1}}>
                <HeadViewWithLeftBtn title = "课程列表"></HeadViewWithLeftBtn>
                {
                    this.props.userType == "student"?<ScrollableTabView renderTabBar={() => <CustomTabBar someProp={'here'} />}>
                        <BookedView tabLabel="预约中"></BookedView>
                        <FinishedView tabLabel="已完成"></FinishedView>
                    </ScrollableTabView>:
                        <ScrollableTabView renderTabBar={() => <CustomTabBar someProp={'here'} />}>
                            <TeacherBookedView tabLabel="预约中"></TeacherBookedView>
                            <TeacherFinishedView tabLabel="已完成"></TeacherFinishedView>
                        </ScrollableTabView>
                }

            </View>
        );
    }
}

const styles = StyleSheet.create({

});
export default CourcesListPage;