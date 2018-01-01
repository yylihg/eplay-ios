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

//图片选择器
// var ImagePicker = require('react-native-image-picker');
//图片选择器参数设置
// var options = {
//     title: '请选择图片来源',
//     cancelButtonTitle:'取消',
//     takePhotoButtonTitle:'拍照',
//     chooseFromLibraryButtonTitle:'相册图片',
//     storageOptions: {
//         skipBackup: true,
//         path: 'images'
//     }
// };

export default class IndividualCenterPage extends Component {

    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            headPortrait: require('../../img/me/icon_me_man.png'),
            userInfo: {}
        }
    }

    componentWillReceiveProps(){
        let context = this;
        if (this.props.viewControllerState == "resume" ){
            ReactModule.getItem("newTime", function (result) {
                if (result && result.value == "true"){
                    ReactModule.setItem("newTime", "false");
                    ReactModule.getItem("birthDate", function (result) {
                        if (result && result.value){
                            context.state.userInfo.BIRTH_DATE = result.value;
                            context.setState({
                                userInfo:context.state.userInfo
                            })
                        }
                    })
                }
            })
        }
    }
    componentDidMount() {
        this._getUserInfo();
    }
    _getUserInfo = () => {
        var context = this;
        ReactModule.fetch("get",{api:"/myinfo/info.do"},function (error, response) {
            console.log('ihg /myinfo/info.do: ', response)
            if (response.code != 0){
            }else {
                let user = response.data.data ||{};
                context.setState({
                    userInfo:user,
                    headPortrait: user.PHOTO0? {uri:user.PHOTO0}:require('../../img/me/icon_me_man.png')
                })
            }
        });
    }


    _onPressButton(id) {
        let context = this;
        switch (id){
            case 1:
                ActionSheetIOS.showActionSheetWithOptions({
                        options: ["女", "男", "取消"],
                        cancelButtonIndex: 2
                    },
                    (buttonIndex) => {
                        if (buttonIndex == 2){
                            return;
                        }
                        context.state.userInfo.SEX = buttonIndex;
                        context.setState({
                            userInfo:context.state.userInfo
                        })
                    });
                break
            case 2:
                ReactModule.pushReactViewController(findNodeHandle(this), "PickDatePage", {});
                break
            case 3:
                AlertIOS.prompt('设置昵称', "",[
                    {
                        text: '取消',
                        onPress: function (e) {

                        }
                    },{
                        text: '确定',
                        onPress: function (value) {
                            if (value){
                                context.state.userInfo.NICK_NAME = value;
                                context.setState({
                                    userInfo:context.state.userInfo
                                })
                            }
                        }
                    }
                ])
                break
            case 5:
                break;
            default:
                break;
        }
    }


    _updateIndividualInfo(){
        let params = {
            nickName: this.state.userInfo.NICK_NAME,
            sex: this.state.userInfo.SEX,
            birthday: this.state.userInfo.BIRTH_DATE,
            cityCode: "2323"
        }
        ReactModule.fetch("post",{api:"/myinfo/updateInformation.do",params: params },function (error, response) {
            console.log('ihg /myinfo/updateInformation.do', response)
            if (response.code == 0){
                alert('更新成功')
            }
        });
    }

    // _chooseImg(){
    //     return;
    //     ImagePicker.showImagePicker(options, (response) => {
    //         console.log('Response = ', response);
    //
    //         if (response.didCancel) {
    //             console.log('用户取消了选择！');
    //         }
    //         else if (response.error) {
    //             alert("ImagePicker发生错误：" + response.error);
    //         }
    //         else if (response.customButton) {
    //             alert("自定义按钮点击：" + response.customButton);
    //         }
    //         else {
    //             console.log("headPortrait ihg:", JSON.stringify(response))
    //             // alert(JSON.stringify(response))
    //             // You can also display the image using data:
    //             let source = { uri: 'data:image/jpeg;base64,' + response.data };
    //             this.setState({
    //                 headPortrait: source
    //             });
    //
    //             let params = {
    //                 base64Data: 'data:image/jpeg;base64,' + response.data
    //             }
    //             // alert(JSON.stringify(params))
    //             // ReactModule.fetch("post",{api:"/fileManager/uploadBase64.do",params: params },function (error, response) {
    //             //     console.log('ihg /fileManager/uploadBase64.do', response)
    //             //     if (response.code == 0){
    //             //         alert('更新成功')
    //             //     }
    //             // });
    //         }
    //     });
    // }

    onDateChange= function(date) {
        this.setState({date: date});
    }
    render() {
        let context = this;
        return (
            <View>
                <HeadViewWithLeftBtn title = "个人中心"></HeadViewWithLeftBtn>
                <ScrollView style = {{marginBottom: 70}}>
                    <View style={styles.headContainer}>
                        <TouchableHighlight underlayColor = '#eee'>
                            <Image style={styles.iconImg} source={this.state.headPortrait} />
                        </TouchableHighlight>
                    </View>
                    <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(1)}>
                        <View style={styles.btnStyle}>
                            <Image style={styles.btnImg} source={require('../../img/me/icon_sex_boy.png')} />
                            <Text style={styles.btnText}>{this.state.userInfo.SEX == "1"?"男":"女"}</Text>
                            <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                        </View>
                    </TouchableHighlight>
                    <View style={styles.btnLine}></View>
                    <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(2)}>
                        <View style={styles.btnStyle}>
                            <Image style={styles.btnImg} source={require('../../img/me/icon_birthday.png')} />
                            <Text style={styles.btnText}>{this.state.userInfo.BIRTH_DATE?this.state.userInfo.BIRTH_DATE:"未设置"}</Text>
                            <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                        </View>
                    </TouchableHighlight>
                    <View style={styles.btnLine}></View>
                    <TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(3)}>
                        <View style={styles.btnStyle}>
                            <Image style={styles.btnImg} source={require('../../img/me/icon_nickname.png')} />
                            <Text style={styles.btnText}>{this.state.userInfo.NICK_NAME?this.state.userInfo.NICK_NAME:"未设置"}</Text>

                            <Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />
                        </View>
                    </TouchableHighlight>
                    {/*<View style={styles.btnLine}></View>*/}
                    {/*<TouchableHighlight underlayColor = '#eee' onPress={()=>this._onPressButton(4)}>*/}
                        {/*<View style={styles.btnStyle}>*/}
                            {/*<Image style={styles.btnImg} source={require('../../img/me/icon_location.png')} />*/}
                            {/*<Text style={styles.btnText}>未设置</Text>*/}
                            {/*<Image style={styles.rightArrow} source={require('../../img/icon_right_arrow.png')} />*/}
                        {/*</View>*/}
                    {/*</TouchableHighlight>*/}
                    <View style={styles.btnLine}></View>

                    <TouchableHighlight underlayColor = '#eee' style={styles.updateBtn} onPress={()=>this._updateIndividualInfo()}>
                        <Text style={styles.updateBtnText}>更新个人信息</Text>
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

