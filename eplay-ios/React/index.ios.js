'use strict'

import {AppRegistry} from 'react-native';

import ReactIosProject from "./component/ReactIosProject"
AppRegistry.registerComponent('ReactIosProject', () => ReactIosProject);

import IndividualView from "./views/me/IndividualPage"
AppRegistry.registerComponent('IndividualView', () => IndividualView);

import HomeView from "./views/home/HomePage"
AppRegistry.registerComponent('HomeView', () => HomeView);

import SeeView from "./views/see/SeePage"
AppRegistry.registerComponent('SeeView', () => SeeView);

import CollectListPage from "./views/me/CollectListPage"
AppRegistry.registerComponent('CollectListPage', () => CollectListPage);
//购买的视频
import BoughtVideoListPage from "./views/me/BoughtVideoListPage"
AppRegistry.registerComponent('BoughtVideoListPage', () => BoughtVideoListPage);
//课程列表
import CourcesListPage from "./views/me/CourcesListPage"
AppRegistry.registerComponent('CourcesListPage', () => CourcesListPage);

//约课
import SelectCourcesPage from "./views/cources/SelectCourcesPage"
AppRegistry.registerComponent('SelectCourcesPage', () => SelectCourcesPage);


//教师详情
import TeacherDetailPage from "./views/teacher/TeacherDetailPage"
AppRegistry.registerComponent('TeacherDetailPage', () => TeacherDetailPage);
//约课
import BookPage from "./views/cources/BookPage"
AppRegistry.registerComponent('BookPage', () => BookPage);
//约课
import VideoListPage from "./views/video/VideoListPage"
AppRegistry.registerComponent('VideoListPage', () => VideoListPage);
//约课
import TeacherListPage from "./views/teacher/TeacherListPage"
AppRegistry.registerComponent('TeacherListPage', () => TeacherListPage);
//约课
import IndividualCenterPage from "./views/me/IndividualCenterPage"
AppRegistry.registerComponent('IndividualCenterPage', () => IndividualCenterPage);
//积分
import IntegralPage from "./views/me/IntegralPage"
AppRegistry.registerComponent('IntegralPage', () => IntegralPage);
//团购
import GroupBuyDetailPage from "./views/cources/GroupBuyDetailPage"
AppRegistry.registerComponent('GroupBuyDetailPage', () => GroupBuyDetailPage);
//团购
import PickDatePage from "./views/me/PickDatePage"
AppRegistry.registerComponent('PickDatePage', () => PickDatePage);

import SelectDateTimePage from "./views/me/SelectDateTimePage"
AppRegistry.registerComponent('SelectDateTimePage', () => SelectDateTimePage);

import ModifyCourceTimePage from "./views/me/ModifyCourceTimePage"
AppRegistry.registerComponent('ModifyCourceTimePage', () => ModifyCourceTimePage);

import FinishCourcePage from "./views/me/FinishCourcePage"
AppRegistry.registerComponent('FinishCourcePage', () => FinishCourcePage);

import TeacherGroupView from "./views/group/TeacherGroupView"
AppRegistry.registerComponent('TeacherGroupView', () => TeacherGroupView);

import TeacherGroupBuyDetailPage from "./views/group/TeacherGroupBuyDetailPage"
AppRegistry.registerComponent('TeacherGroupBuyDetailPage', () => TeacherGroupBuyDetailPage);

import StudentGroupListPage from "./views/group/StudentGroupListPage"
AppRegistry.registerComponent('StudentGroupListPage', () => StudentGroupListPage);

import StudentGroupBuyDetailPage from "./views/group/StudentGroupBuyDetailPage"
AppRegistry.registerComponent('StudentGroupBuyDetailPage', () => StudentGroupBuyDetailPage);

import TeacherTeamListPage from "./views/team/TeacherTeamListPage"
AppRegistry.registerComponent('TeacherTeamListPage', () => TeacherTeamListPage);

import StudentTeamListView from "./views/team/StudentTeamListView"
AppRegistry.registerComponent('StudentTeamListView', () => StudentTeamListView);

import AboutPage from "./views/me/AboutPage"
AppRegistry.registerComponent('AboutPage', () => AboutPage);

import TeamDetailPage from "./views/team/TeamDetailPage"
AppRegistry.registerComponent('TeamDetailPage', () => TeamDetailPage);