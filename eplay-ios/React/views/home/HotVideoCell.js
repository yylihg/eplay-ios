/**
 * Created by yanlin.yyl.
 */
'use strict';

import  {
    View,
    Text,
    Image,
    TouchableHighlight,
    StyleSheet
} from 'react-native';

import React, {Component} from 'react';

class HotVideoCell extends Component {

    render() {
        return (
            <TouchableHighlight
                style={styles.container}
                onPress={this.props.onPress}
                underlayColor="rgb(210, 230,255)">
                <View style={styles.container}>
                    <Image style={styles.imageIcon} source={this.props.imageUrl}/>
                    <View style={styles.listItemText}>
                        <Text numberOfLines={1} style={styles.titleStyle}>{this.props.video.VIDEO_NAME}</Text>
                        <Text numberOfLines={2} style={styles.listItemDes}>{this.props.video.VIDEO_REMARK}</Text>
                    </View>
                </View>
            </TouchableHighlight>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        height: 68,
        alignItems: 'center',
        borderBottomColor: '#eee',
        borderBottomWidth: 1
    },
    imageIcon: {
        marginLeft: 10,
        height: 50,
        width: 68
    },
    titleStyle: {
        color: '#666',
        fontSize: 14
    },
    listItemText: {
        marginLeft: 10
    },
    listItemDes: {
        fontSize: 12,
        marginTop: 8,
        color: '#999'
    }
});

export default HotVideoCell;