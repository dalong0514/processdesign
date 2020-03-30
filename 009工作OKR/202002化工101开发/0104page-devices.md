# 0201page-devices

## 01. wxml

### 原始代码

```
<!--pages/devices/devices.wxml-->
<i-toast id="toast" />
<view class='page'>
  <loading hidden="{{!loading}}">加载中...</loading>
  <view class="page__hd weui-flex tz-device-header" style="width:100%;position:fixed;top:0;z-index:100">
    <view class="device-category">
      <image bindtap="doSearch" class="img-category" src='/images/device/category.png' />
    </view>
    <view class='weui-flex__item tz-search'>
      <view class="weui-search-bar__form" bindtap='doSearch'>
        <view class="weui-search-bar__box">
          <view class='weui-search-bar__input'></view>
        </view>
        <label class="weui-search-bar__label">
          <icon class="weui-icon-search" type="search" size="14"></icon>
          <view class="weui-search-bar__text">{{search_txt}}</view>
        </label>
      </view>
    </view>
  </view>
  <view class="device-swiper" style="margin-top:55px">
    <swiper indicator-dots="{{indicatorDots}}" autoplay="{{autoplay}}" interval="{{interval}}" duration="{{duration}}" class='device-swiper__container'>
      <view wx:for="{{banner}}" wx:key="unique">
        <swiper-item bindtap="viewProductDetail" data-idx="{{item.param_id}}" data-type="{{item.param_type}}">
          <image src='{{item.image}}' style='height:100%;width:100%;border-radius:6px' />
        </swiper-item>
      </view>
    </swiper>
  </view>
  <view class='static-display-product'>
    <view class='weui-flex' wx:for="{{type}}" wx:for-index="idx">
      <view class='weui-flex__item' bindtap="productList" data-label="{{cell.id}}" wx:for="{{type[idx]}}" wx:for-item="cell">
        <view>
          <image class="img-device-display" src='{{cell.logo}}' />
        </view>
        <view class='device-label'>{{cell.name}}</view>
      </view>
    </view>
  </view>
  <view class='device-list'>
    <view class='device-list-header'>
      <view class='weui-flex'>
        <view class='weui-flex__item device-list-label'>
          <text>推荐产品</text>
        </view>
        <view class='weui-flex__item device-list-more'>
          <text class="device-list-more-label" bindtap='more'>更多产品</text>
        </view>
        <view class='device-list-more-icon'>
          <image src='/images/device/more.png' class="more" />
        </view>
      </view>
      <view class='device-list-content'>

      </view>
    </view>
    <view class='device-list-content'>
      <block wx:for="{{product}}" wx:key="unique" wx:for-index="idx">
        <view class='item'>
          <image bindtap="viewProductDetail" data-idx="{{item.id}}" data-type="1" src='{{item.cover_image}}' style="width:123px;height:79px;display:flex;padding-left:10px;padding-right:10px" />
          <view class='meta'>
            <view bindtap="viewProductDetail" data-idx="{{item.id}}" data-type="1" class='title'>{{item.name}}</view>
            <view bindtap="viewProductDetail" data-idx="{{item.id}}" data-type="1" class='content'>{{item.describe}}</view>
            <view class='tag-fav'>
              <view class='view-tag'>
                <text class="text-tag" wx:for="{{item.label}}" wx:key="idx">{{item}}</text>
              </view>
              <view class='view-fav'>
                <text class='text-fav' data-id="{{item.id}}" data-idx="{{idx}}" bindtap="cancelCollect" wx:if="{{item.is_collect == 1}}">- 取消收藏({{item.collect_count}})</text>
                <text class='text-fav' data-id="{{item.id}}" data-idx="{{idx}}" bindtap="doCollect" wx:else>+ 收藏({{item.collect_count}})</text>
              </view>
            </view>
          </view>
        </view>

      </block>
    </view>
  </view>
</view>
```

### 修改记录

1、swiper 组件里增加属性 circular="{{true}}"，实现循环轮动。


20200310

```

```

## 02. js

原始代码：

```
// pages/devices/devices.js
const { $Toast } = require('../../lib/iview/base/index');
Page({

  /**
   * Page initial data
   */
  data: {
    search_txt: '',
    loading: true,
    banner: [],
    indicatorDots: true,
    autoplay: true,
    interval: 5000,
    duration: 800,
    product: [],
    type: [],
  },

  /**
   * Lifecycle function--Called when page load
   */
  onLoad: function (options) {
    this.getData();
  },

  getData: function() {
    var _that = this;
    wx.request({
      url: 'https://www.hg101.vip/api/home',
      header: {
        "openid": wx.getStorageSync('open_id'),
      },
      success: (res => {
        _that.setData({
          loading: false,
        });
        if(res.data.code == 0) {
          _that.setData({
            banner: res.data.data.banner,
            product: res.data.data.product,
            type: res.data.data.type,
          })
        }
      }),
      fail: (res => {
        $Toast({
          content: '异常错误',
          type: 'error'
        })
      }),
    })
    wx.request({
      url: 'https://www.hg101.vip/api/problem_txt',
      header: {
        "openid": wx.getStorageSync('open_id')
      },
      success: (res => {
        _that.setData({
          loading:false,
        });
        if(res.data.code == 0) {
          _that.setData({
            search_txt: res.data.data.search_txt
          })
        }
      }),
      fail: (res => {
        $Toast({
          content: '异常错误',
          type: 'error'
        })
      }),
    })
  },
  /**
   * Lifecycle function--Called when page is initially rendered
   */
  onReady: function () {

  },

  /**
   * Lifecycle function--Called when page show
   */
  onShow: function () {

  },

  /**
   * Lifecycle function--Called when page hide
   */
  onHide: function () {

  },

  /**
   * Lifecycle function--Called when page unload
   */
  onUnload: function () {

  },

  /**
   * Page event handler function--Called when user drop down
   */
  onPullDownRefresh: function () {

  },

  /**
   * Called when page reach bottom
   */
  onReachBottom: function () {

  },

  /**
   * Called when user click on the top right corner to share
   */
  onShareAppMessage: function () {

  },

  doSearch: function() {
    wx.navigateTo({
      url: '/pages/devices/search',
    })
  },

  viewProductDetail: function(e) {
    var id = e.currentTarget.dataset.idx;
    var type = e.currentTarget.dataset.type;
    wx.navigateTo({
      url: `/pages/devices/detail?id=${id}&type=${type}`,
    })
  },

  doCollect: function(e) {
    let id = e.currentTarget.dataset.idx;
    let product_id = e.currentTarget.dataset.id;
    console.log('doCollect' + id)
    this.collect(id, false, 1, product_id, 2)
  },

  cancelCollect: function(e) {
    let id = e.currentTarget.dataset.idx;
    let product_id = e.currentTarget.dataset.id;
    console.log('cancelCollect' + id)
    this.collect(id, true, 1, product_id, 2);
  },

  collect: function (id, status, entry_type, entry_id, type){
    wx.request({
      method: 'POST',
      url: 'https://www.hg101.vip/api/like',
      header: {
        'openid': wx.getStorageSync('open_id'),
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      data: {
        entry_type: entry_type,
        entry_id: entry_id,
        type: type,
      },
      success: (res => {
        let favNum = status ? this.data.product[id].collect_count - 1 : this.data.product[id].collect_count + 1;
        let favNumKey = `product[${id}].collect_count`;
        let isFavKey = `product[${id}].is_collect`;
        this.setData({
          [favNumKey]: favNum,
          [isFavKey]: status? false: true,
        });
      }),
      fail: (res => {

      }),
    })
  },

  more: (() => {
    wx.navigateTo({
      url: '/pages/product/product',
    })
  }),

  productList: (e => {
    var type = e.currentTarget.dataset.label;
    wx.navigateTo({
      url: `/pages/product/product?type=${type}`,
    })
  }),

})

```






## 03. wxss

原始代码：

```
/* pages/devices/detail.wxss */
@import "../../components/wxParse/wxParse.wxss";
.product-header {
  display: flex;
  flex-direction: row;
  background: #fff;
}
.tab-text {
  color: rgb(255, 68, 67) 100%;
  font-size: 16px;
  padding-top: 8px;
  padding-bottom: 5px;
}
.tab-item .active {
  border-bottom: 1px solid rgba(255, 68, 67, 1);
  color: rgba(255, 68, 67, 1);
}
.tab-item {
  display: flex;
  flex: 1;
  text-align: center;
  justify-content: center;
}
.product-content {
  margin: 20px;
}
.title {
  color: rgba(136, 128, 128, 1);
  font-size: 14px;
  padding-left: 10px;
  border-left: 1.5px solid rgba(255, 68, 67, 1);
}
.text-label {
  font-size: 14px;
  color: rgba(136, 128, 128, 1);
  padding: 10px;
  line-height: 1.8;
  text-indent: 50rpx;
}
.hidden {
  display: none;
}
```









