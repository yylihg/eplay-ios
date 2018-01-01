/**
 * 乐器单元格
 * Created by ihg on 2017/4/15.
 */
'use strict';

import  {
    Dimensions,
    TouchableOpacity,
    Image,
    StyleSheet
} from 'react-native';

import React, {Component} from 'react';

import ViewPager from 'react-native-viewpager';
var deviceWidth = Dimensions.get('window').width;


import RequestUtils from '../../utils/RequestUtils';

// 用于构建DataSource对象
var dataSource = new ViewPager.DataSource({
    pageHasChanged: (p1, p2) => p1 !== p2,
});

class Banner extends Component  {

    static defaultProps = {
        datas: []
    }

    //noinspection JSAnnotator
    constructor(props: Object) {
        super(props)
        this._renderPage = this._renderPage.bind(this);
        this.state = {
            images: dataSource.cloneWithPages([])
        }
    }

    componentDidMount() {
        // this.requestDiscount();
        this._getBanner();
    }


    _getBanner = function () {
        var context = this;
        RequestUtils.fetch(context,"get",{api:"/banner/list.do?pageSize=10&start=0"},function (response) {
            console.log("ihg /banner/list.do: sss", response);
            context.setState({
                images: dataSource.cloneWithPages(response.data.list || [])
            })
        });
    }

    _viewPageItemClick = function (pageID) {
        // alert('click:' + pageID )
    }

    //noinspection JSAnnotator
    _renderPage=  function(
        data: Object,
        pageID: number | string,) {
        return (
            <TouchableOpacity onPress={() =>this._viewPageItemClick(pageID)}>
                <Image
                    source={{uri: data.IMG_URL}}
                    style={styles.page} />
            </TouchableOpacity>
        );
    }

    render() {
        return (

            <ViewPager
                style={styles.pageH}
                dataSource={this.state.images}
                renderPage={this._renderPage}
                isLoop={false}
                autoPlay={true}/>
        );
    }
}

const styles = StyleSheet.create({
    page: {
        width: deviceWidth,
        height: 150
    },
    pageH: {
        width: deviceWidth,
        height: 150,
    }
});

export default Banner;