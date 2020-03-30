# 0202page-account

问题：修改的时候，在开发版遇到「内存不足，请重新打开小程序」的提示。


## 01. wxml

### 原始代码

```
<view class='page'>
  <loading hidden="{{!loading}}">加载中...</loading>
  <view class='top' style='position:fixed;top:0px;width:100%;z-index:100'>
    <view class='user-info'>
      <view class='user-avatar'>
        <open-data type="userAvatarUrl"></open-data>
      </view>
      <view class='user-nickname'>
        <open-data type="userNickName"></open-data>
      </view>
    </view>
    <view class="tab">
      <view class="tab-list" data-idx="0" bindtap="switchTab">
        <text class="tab-text {{currentTab == 0 ? 'active' : ''}}">收藏 {{collect_count}}</text>
      </view>
      <view class="tab-list" data-idx="1" bindtap="switchTab">
        <text class="tab-text {{currentTab == 1 ? 'active' : ''}}">点赞 {{like_count}}</text>
      </view>
    </view>
  </view>
  
  <scroll-view class="{{currentTab == 0 ? '': 'hidden'}}" scroll-y="true" style='margin-top:380rpx'>
    <block wx:for="{{collect}}" wx:key="unique">
      <slide-delete pid="{{item.id}}" bindaction="handleCollectSlideDelete" >
        <view class='item' data-entry="{{item.entry_type}}" data-idx="{{item.entry_id}}" bindtap='viewProductDetail'>
          <image src='{{item.entry.cover_image}}' style="width:123px;height:79px;" />
          <view class='meta'>
            <view class='title'>{{item.entry.name}}</view>
            <view class='content'>{{item.entry.describe}}</view>
            <view class='tag'>
              <span wx:for="{{item.entry.label}}" class="tag-span">{{item}}</span>
            </view>
          </view>
        </view>
      </slide-delete>
    </block>
    
  </scroll-view>
  <scroll-view class="{{currentTab == 1 ? '': 'hidden'}}" scroll-y="true" style='margin-top: 380rpx'>
    <block wx:for="{{like}}" wx:key="unique">
      <slide-delete pid="{{item.id}}" bindaction="handleLikeSlideDelete">
        <view class='item' data-entry="{{item.entry_type}}" data-idx="{{item.entry_id}}" bindtap="viewProductDetail">
          <image src='{{item.entry.cover_image}}' style="width:123px;height:79px;" />
          <view class='meta'>
            <view class='title'>{{item.entry.name}}</view>
            <view class='content'>{{item.entry.describe}}</view>
            <view class='tag'>
              <span class="tag-span" wx:for="{{item.entry.label}}">{{item}}</span>
            </view>
          </view>
        </view>
      </slide-delete>
    </block>
  </scroll-view>
  
</view>
```

### 修改代码记录

```
<view class='page'>
  <loading hidden="{{!loading}}">加载中...</loading>
  <!-- 个人信息 -->
  <view class='top' style='position:fixed;top:0px;width:100%;z-index:100'>
    <view class='user-info'>
      <view class='user-avatar'>
        <open-data type="userAvatarUrl"></open-data>
      </view>
      <view class='user-nickname'>
        <open-data type="userNickName"></open-data>
      </view>
    </view>
    <view class="tab-list" data-idx="0" bindtap="switchTab">
      <text class="tab-text">收藏 {{collect_count}}</text>
    </view>
  </view>

  <scroll-view scroll-y="true" style='margin-top:380rpx'>
    <block wx:for="{{collect}}" wx:key="unique">
      <slide-delete pid="{{item.id}}" bindaction="handleCollectSlideDelete" >
        <view class='item' data-entry="{{item.entry_type}}" data-idx="{{item.entry_id}}" bindtap='viewProductDetail'>
          <image src='{{item.entry.cover_image}}' style="width:123px;height:79px;" />
          <view class='meta'>
            <view class='title'>{{item.entry.name}}</view>
            <view class='content'>{{item.entry.describe}}</view>
            <view class='tag'>
              <span wx:for="{{item.entry.label}}" class="tag-span">{{item}}</span>
            </view>
          </view>
        </view>
      </slide-delete>  
    </block>
  </scroll-view>

</view>
```

slide-delete 表示左滑删除的组件。

## 02. js 文件

### 原始代码

```
// pages/account/account.js
Page({

  /**
   * Page initial data
   */
  data: {
    currentTab: 0,
    loading: true,
    like: [],
    collect: [],
    like_count: 0,
    collect_count: 0,
  },

  /**
   * Lifecycle function--Called when page load
   */
  onLoad: function (options) {
    this.getLikeAndCollect()
  },

  getLikeAndCollect: function() {
    var that = this
    wx.request({
      url: 'https://www.hg101.vip/api/likeList',
      header: {
        'openid': wx.getStorageSync('open_id'),
      },
      success: function(res) {
        console.log(res);
        if(res.data.code == 0) {
          that.setData({
            like_count: res.data.data.like_count,
            collect_count: res.data.data.collect_count,
            like: res.data.data.like,
            collect: res.data.data.collect,
            loading: false,
          })
        }
      }
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

  switchTab: function (e) {
    this.setData({
      currentTab: e.currentTarget.dataset.idx,
    });
  },
  viewProductDetail: function(e) {
    let id = e.currentTarget.dataset.idx;
    let entry = e.currentTarget.dataset.entry;
    console.log(entry)
    wx.navigateTo({
      url: `/pages/devices/detail?id=${id}&type=${entry}`,
    })
  },
  handleCollectSlideDelete({ detail: { id } }) {
    var that = this
    let collect = this.data.collect;
    let collect_index = collect.findIndex(item => item.id == id)
    if(collect_index != -1) {
      let id = collect[collect_index].entry_id
      wx.request({
        url: 'https://www.hg101.vip/api/like',
        method: 'POST',
        header: {
          'openid': wx.getStorageSync('open_id')
        },
        data: {
          entry_type: 1,
          entry_id: id,
          type: 2
        },
        success: function(res) {
          if(res.data.code == 0) {
            collect.splice(collect_index, 1)
            that.setData({
              collect: collect
            })
          }
        }
      })
    }
  },

  handleLikeSlideDelete({ detail: { id } }) {
    var that = this
    let like = this.data.like;
    let like_index = like.findIndex(item => item.id == id)
    if (like_index != -1) {
      let id = like[like_index].entry_id
      wx.request({
        url: 'https://www.hg101.vip/api/like',
        method: 'POST',
        header: {
          'openid': wx.getStorageSync('open_id'),
        },
        data: {
          entry_type: 2,
          entry_id: id,
          type: 1
        },
        success: function(res) {
          if(res.data.code == 0) {
            like.splice(like_index, 1)
            that.setData({
              like: like
            })
          }
        }
      })
    }
  },
})

```


## 03. wxss

原始代码：

```
/* pages/account/account.wxss */
.page {
  width: 100%;
  height: 100%;
}
.user-info {
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 300rpx;
  align-items: center;
  background-repeat: no-repeat;
  background-size: 100% 300rpx;
  text-align: center;
  background-image: url('https://ws4.sinaimg.cn/large/006tKfTcly1g0uedgy9ewj30ku08c745.jpg');
}
.user-avatar {
  width: 120rpx;
  height: 120rpx;
  margin-top: 60rpx;
  border-radius: 120rpx;
  border: 6rpx solid #fff;
  overflow: hidden;
  box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);  
}

.user-nickname {
  color: #fff;
  font-size: 28rpx;
  margin-top: 25rpx;
}
.tab{
  display: flex;
  border-bottom: 1px solid #eee;
  background-color: #fff;
}
.tab-list{
  flex: 1.0;
  text-align: center;
  font-size: 14px;
  color: #999;
  margin-bottom: -1px;
}
.tab-text {
  display: block;
  width: 45px;
  padding: 10px;
  margin: auto;
}
.tab-text .active{
  border-bottom: 2px solid #F65959;
  color: #000;
  font-weight: bold;
}
.active{
  color:#F65959;
  border-bottom: 4rpx solid #F65959;
}
.item{
  display: flex;
  padding: 10px;
  margin: 10px;
  justify-content: flex-start;
  border-radius: 5px;
  border: 1px solid rgba(238, 233, 233, 1);
}
.meta {
  display: flex;
  flex: 1;
  flex-direction: column;
  text-align: left;
  margin-left: 10px;
}
.title {
  color: rgba(16, 16, 16, 1);
  font-size: 18px;
}
.content {
  font-size: 12px;
  color: rgba(16, 16, 16, 1);
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}
.tag-span {
  font-size: 12px;
  color: rgb(16, 16, 16) 100%;
  border: 1px solid rgba(204, 198, 198, 1);
  border-radius: 10px;
  padding: 3px 8px 3px 8px;
  margin-top: 10px;
  margin-bottom: 10px;
  margin-right: 15px;
}
.navigator-hover {
  background-color: white;
  opacity: 1;
}
.hidden {
  display: none;
}
```


