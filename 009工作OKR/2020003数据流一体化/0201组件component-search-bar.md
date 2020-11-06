# 0201. component-search-bar

## 01. 父子组件间数据的传输

父子组件的关系可以总结为 prop 向下传递，事件向上传递。父组件通过 prop 给子组件下发数据，子组件通过事件给父组件发送消息。

非父子组件之间传值，需要定义个公共的公共实例文件 bus.js，作为中间仓库来传值，不然路由组件之间达不到传值的效果。

1『非父子组件间传递数据也可以通过 vuex 实现。』

## 02. 向服务端请求数据

```js
getData() {
  var that = this;
  let urldata = {
    method: 'get',
    url:'http://test.hg101.vip/admin/getRoomData',
  };
  axios(urldata).then(function(response) {
    // console.log(response.data);
    that.requestdata = response.data.data;
    that.handleData(response.data.data);
  })
  .catch(function(e) {
    console.log(e.data.status.msg);
  });
},
```

关键是这里的「var that = this;」，因为这里 this 绑定不到全局对象上，猜测是异步函数的原因，赋值的语句是在请求发送后获取的 promise 对象里，具体的原因目前还没弄清楚。（2020-05-18）

另外一个关键点是请求函数必须放在页面被加载时的钩子里，如果放在常规的加载后，必须要调用 2 次函数才能获取数据，应该还是一部函数导致的。经测试，放在 mounted 或者 beforeMount 里都可以。

[API — Vue.js](https://cn.vuejs.org/v2/api/#beforeMount)

```js
beforeMount() {
// this.getData();
},
mounted() {
this.getData();
},
```

