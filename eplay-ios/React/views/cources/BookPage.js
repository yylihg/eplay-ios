/**
 * Created by yanlin.yyl.
 */
'use strict';

import  {
    View,
    Text,
    Image,
    TouchableHighlight,
    StyleSheet,
    NativeModules
} from 'react-native';

import React, {Component} from 'react';

import HeadViewWithLeftBtn from '../common/HeadViewWithLeftBtn';
import RadioButton from '../cources/RadioButton';
var ReactModule = NativeModules.ReactModule;
var findNodeHandle = require('findNodeHandle');

import ListLine from '../common/ListLine';
import DatePicker from 'react-native-datepicker'
import Toast, {DURATION} from 'react-native-easy-toast'
import screen from '../../constants/screen';


export default class BookPage extends Component {
    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            instrumentType: [],
            courceType: [],
            orderName: '约课' +this.props.id,
            classType: '',
            teachMode: '',
            appointmentTime: ''
        }
    }

    componentDidMount() {
        this._getCourceList();
        this._getInstrumentList();
    }
    _getCourceList = function () {
        var context = this;
        ReactModule.fetch("get",{api:"/dictionaries/findByCode.do?code=CLASS_TYPE"},function (error, response) {
            console.log('ihg /dictionaries/findByCode.do:CLASS_TYPE ', response)
            if (error){

            }else {
                let list = response.data.list || [];
                for (let i = 0; i < list.length; i++){
                    list[i].key = '' + i;
                    list[i].isSelected = false;
                }
                context.setState({
                    courceType: list
                });
            }
        });
    }
    _getInstrumentList = function () {
        var context = this;
        ReactModule.fetch("get",{api:"/course/teacherClassType.do?teacherUserId="+this.props.id},function (error, response) {
            console.log('ihg /course/teacherClassType.do', response)
            if (error){

            }else {
                let list = response.data.list || [];
                for (let i = 0; i < list.length; i++){
                    list[i].key = '' + i;
                    list[i].isSelected = false;
                }
                context.setState({
                    instrumentType: list
                });
            }
        });
    }

    _onCourceItemSelected(index){
        this.setState({teachMode: this.state.courceType[index].CODE})
    }
    _onInstrumentItemSelected(index){
        this.setState({classType: this.state.instrumentType[index].CODE})
    }
    render() {
        return (
            <View>
                <HeadViewWithLeftBtn title = "约课"></HeadViewWithLeftBtn>
                <Text style={styles.radioTitle}>乐器类别</Text>
                <RadioButton datas = {this.state.instrumentType} onItemSelected={(index) => this._onInstrumentItemSelected(index)}></RadioButton>
                <ListLine ></ListLine>
                <Text style={styles.radioTitle}>教学类型</Text>
                <RadioButton datas = {this.state.courceType} onItemSelected={(index) => this._onCourceItemSelected(index)}></RadioButton>
                <ListLine ></ListLine>
                <Text style={styles.radioTitle}>预约上课时间</Text>
                <DatePicker
                    style = {styles.datePickStyle}
                    date={this.state.date}
                    mode="datetime"
                    placeholder="请选择上课时间"
                    format="YYYY-MM-DD HH:MM"
                    minDate= {this._getCurrentTime()}
                    confirmBtnText="确定"
                    cancelBtnText="取消"
                    iconSource = {require('../../img/icon_time_picker.png')}
                    customStyles={{
                        dateTouch:{
                            marginLeft: 20,
                            marginRight:20,
                            width: 300
                        },
                        dateIcon: {
                            position: 'absolute',
                            right: 20,
                            height: 13,
                            width: 13,
                            marginLeft: 0
                        },
                        dateInput:{
                            borderWidth: 0,
                            justifyContent:'center',
                            alignItems: 'flex-start',
                        },
                        dateTouchBody: {
                            marginLeft: 20,
                            marginRight:20,
                            width: screen.width - 60,
                            height: 32,
                            borderWidth: 0,
                            borderRadius: 5,
                            backgroundColor: '#eee'
                        }
                        // ... You can check the source to find the other keys.
                    }}
                    onDateChange={(date) => {this.setState({appointmentTime: date,date: date})}}
                />
                <ListLine style={{marginTop: 23}}></ListLine>
                <TouchableHighlight underlayColor = '#eee' style={styles.bookBtn} onPress={()=>this._onBookClick()}>
                    <Text style={styles.btnText}>提交</Text>
                </TouchableHighlight>
                <Toast ref="toast"/>
            </View>
        );
    }

    _getCurrentTime(){
        var date = new Date();
        var seperator1 = "-";
        var seperator2 = ":";
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + date.getMinutes();
        return currentdate;
    }

    _onBookClick() {
        // console.log('ihg',"book");
        if (!this.state.appointmentTime){
            alert("时间不能不填哦～");
            return;
        }
        if (!this.state.classType){
            alert("乐器类别不能不填哦～");
            return;
        }
        if (!this.state.teachMode){
            alert("教学类型不能不填哦～");
            return;
        }
        let params = {
            orderName: this.state.orderName,
            classType: this.state.classType,
            teachMode: this.state.teachMode,
            teacherUserId: this.props.id,
            appointmentTime: this.state.appointmentTime,
        }
        let context = this;
        ReactModule.fetch("post",{api:"/course/appointmentClass.do",params: params },function (error, response) {
            console.log('ihg /course/appointmentClass.do', response)
            if (!error && response.code == 0){
                context.refs.toast.show('约课成功！');
                setTimeout(
                    () => {
                        ReactModule.podViewController(findNodeHandle(context));
                    },500);
            }
        });
    }
}

const styles = StyleSheet.create({
    btnText:{
        fontSize:16,
        color: '#fff',
        marginLeft: 10
    },
    bookBtn:{
        marginTop:100,
        height: 34,
        marginLeft: 20,
        marginRight:20,
        borderRadius: 10,
        backgroundColor: '#0168ae',
        borderColor: "#999",
        alignItems:'center',
        justifyContent: 'center'
    },
    radioTitle: {
        marginLeft: 20,
        marginTop: 10,
        fontSize: 14,
        color:'#666'
    },
    datePickStyle: {
        marginTop: 15,
        marginBottom: 23,
        marginLeft: 20,
        marginRight:20,
        height: 32,
        borderRadius: 5,
        backgroundColor: '#eee'
    }


});