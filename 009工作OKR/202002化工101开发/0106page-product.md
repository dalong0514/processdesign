# 0203page-product

## 01. wxml

### 原始代码

```
<!--pages/product/product.wxml-->
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
```

## 02. js

### 原始代码

```
// pages/product/product.js
Page({

  /**
   * Page initial data
   */
  data: {
    product: [],
  },

  /**
   * Lifecycle function--Called when page load
   */
  onLoad: function (options) {
    var that = this
    var type = options.type
    wx.request({
      url: 'https://www.hg101.vip/api/screen' + (type ? `?type=${type}` : ''),
      header: {
        'openid': wx.getStorageSync('open_id')
      },
      success: function(res) {
        if(res.data.code == 0) {
          that.setData({
            product: res.data.data
          })
        }
      }
    })
  },

  doCollect: function (e) {
    let id = e.currentTarget.dataset.idx;
    let product_id = e.currentTarget.dataset.id;
    console.log('doCollect' + id)
    this.collect(id, false, 1, product_id, 2)
  },

  cancelCollect: function (e) {
    let id = e.currentTarget.dataset.idx;
    let product_id = e.currentTarget.dataset.id;
    console.log('cancelCollect' + id)
    this.collect(id, true, 1, product_id, 2);
  },

  collect: function (id, status, entry_type, entry_id, type) {
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
          [isFavKey]: status ? false : true,
        });
      }),
      fail: (res => {

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

  viewProductDetail: function (e) {
    var id = e.currentTarget.dataset.idx;
    var type = e.currentTarget.dataset.type;
    wx.navigateTo({
      url: `/pages/devices/detail?id=${id}&type=${type}`,
    })
  },
})

```


## 03. wxss

### 原始代码

```
/* pages/product/product.wxss */
.item {
  display: flex;
  justify-content: flex-start;
  background: #fff;
  margin-left: 10px;
  margin-right: 10px;
  margin-bottom: 10px;
  padding: 10px;
  border-radius: 5px;
}
.meta {
  display: flex;
  flex-direction: column;
  flex: 1;
}
.title {
  color: rgba(16, 16, 16, 1);
  font-size: 18px;
}
.content {
  color: rgba(16, 16, 16, 1);
  font-size: 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}
.tag-fav {
  display: flex;
  flex-direction: row;
  margin-top: 8px;
}
.view-tag {
  flex: 10;
}
.text-tag {
  padding: 3px 8px;
  color: rgba(16, 16, 16, 1);
  font-size: 12px;
  border: 1px solid rgba(204, 198, 198, 1);
  border-radius: 10px;
  margin-right: 10px;
}
.text-fav {
  color: #fff;
  margin-top: 6px;
  padding-left: 3px;
  padding-right: 3px;
}
.view-fav {
  border-radius: 8px;
  text-align: center;
  height: 20px;
  font-size: 12px;
  background: rgb(228, 70, 59) 100%;
  margin-top: 3px;
  padding-top: 1.5px;
  padding-left: 5px;
  padding-right: 5px;
}

.device-list-content {
  height: 100%;
  background: rgba(248, 248, 248, 1);
}
```

