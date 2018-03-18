/**
 * Created by yanlin.yyl.
 */
'use strict';

import  {
    View,
    Text,
    TouchableHighlight,
    Animated,
    FlatList,
    NativeModules,
    StyleSheet,
    Image
} from 'react-native';
import SearchView from '../common/SearchView';
import React, {Component} from 'react';

const AnimatedFlatList = Animated.createAnimatedComponent(FlatList);
let currentIndex = 0;
let totalCount = 0;
let currentPage = 0;
import ListLine from '../common/ListLine';
var ReactModule = NativeModules.ReactModule;


export default class TeacherFinishedView extends Component {

    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this.state = {
            cources: []
        }
    }

    componentDidMount() {
        this._getBookedList(currentPage);
    }

    _getBookedList = function (page) {
        var context = this;
        ReactModule.fetch("get", {api: "/course/list.do?start=" + page*10 + "&pageSize=10&orderStatusType=DONE"
        + "&teacherUserId=" + "bd2da6a4bd79435f9256c49c7b2ec8f3"}, function (error, response) {
            console.log('ihg Finish /course/list.do: ', response)
            if (error) {
                currentPage -= 1;
            } else {
                totalCount = response.data.total;
                currentIndex = context.state.cources.length;
                let bookedTemp = response.data.list || [];
                let bookedList = currentPage == 0 ? [] : context.state.cources;
                for (let i = 0; i < bookedTemp.length; i++) {
                    bookedTemp[i].key = currentIndex + "";
                    currentIndex += 1;
                    bookedList.push(bookedTemp[i]);
                }
                context.setState({
                    cources: bookedList
                });
            }
        });
    }

    render() {
        return (
            <View>
                <AnimatedFlatList
                    data={this.state.cources}
                    renderItem={this._renderItemComponent}
                    onEndReached={this._onEndReached}
                    onRefresh={this._onRefresh}
                    refreshing={false}
                />
            </View>
        );
    }

    _onItemPress(item) {
        // alert('click:' + JSON.stringify(item))
    }

    _renderItemComponent = ({item, separators}) => {
        return (
            <TouchableHighlight underlayColor='#eee' onPress={() => this._onItemPress(item)}>
                <View>
                    <View style={styles.listItemContainer}>
                        <Image style={styles.listItemImage} source={{uri: item.TEACHER_IMG_URL}}/>
                        <View style={styles.listItemText}>
                            <Text numberOfLines = {1} style={styles.listItemTitle}>{item.ORDER_NAME}</Text>
                            <Text numberOfLines={2} style={styles.listItemDes}>{item.TEACHER_EXPERIENCE}</Text>
                        </View>
                    </View>
                    <ListLine style ={styles.listItemLine}/>
                </View>
            </TouchableHighlight>
        );

    };

    _onEndReached = () => {
        if (this.state.cources.length < 9) {
            return;
        }
        if (this.state.cources.length < totalCount){
            currentPage += 1;
            this._getBookedList(currentPage);
        }
    };
    _onRefresh = () => {
        currentPage = 0;
        this._getBookedList(currentPage);
    }

}
const styles = StyleSheet.create({

    cancelBtn: {
        backgroundColor: '#d2d2d2',
        justifyContent:'center',
        alignItems: 'center',
        borderRadius: 5,
        width: 45,
        marginTop: 10,
        marginRight: 10,
        height: 30,
    },
    cancelBtnText: {
        color: '#fff',
        fontSize: 16
    },

    listItemContainer: {
        height:66,
        flexDirection: 'row'
    },
    listItemImage: {
        marginLeft: 10,
        width: 68,
        height:50,
        marginTop: 8,
        marginBottom:8
    },
    listItemText: {
        flex: 1,
        marginLeft: 10,
        marginRight: 10,
        justifyContent: 'center'
    },
    listItemTitle: {
        fontSize: 14,
        color: '#666'
    },
    listItemDes: {
        fontSize: 12,
        marginTop: 8,
        color: '#999'
    },
    listItemLine: {
        position:'absolute',
        bottom: 0
    }
});
