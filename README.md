# mvc-base
自用代码库

## 版本迭代记录

### 0.3.7

优化Coredata数据重排序的逻辑

### 0.3.6

左右滑菜单增加针对Model的预先适配Block

### 0.3.5 

修复iOS，tableview左滑右滑菜单bug


### 0.3.4

UIAlertController增加UIBarItem启动方法
View增加调用Presenter传参数拿返回值的接口
增加MVPCellActionModel设计TableView的左右滑动菜单（iOS11开始支持）

### 0.3.3

MVPTableViewOutput和MVPCollectViewOutput增加TableView和CollectionView属性，MVPTableViewOutput增加tableView的Class设置，两个都增加了注册Cell用的Block，和注册Nib的简单方法。

### 0.3.2

CoredataInput增加刷新FetchController的方法
MVPOutputProtocol增加刷新方法
MVPView增加刷新方法，增加执行selector的方法

### 0.3.1

CoredataInput增加结果数量限制

### 0.3.0

修改MVPView的协议接口声明，修改TableOutput默认关闭动画，修改Presenter的BarItem绑定增加sender参数

### 0.2.9

`MVPView`增加navigationItem的生成方法，并且强制设置title，用于给VoiceOver提供提示。
修复tableivew的refreshcontrol和largetitle冲突的问题。

### 0.2.8
`MVPTableViewOutput`增加动画开关。

### 0.2.7
Input增加删除obj的方法。

### 0.2.6
`MVPComplexInput`增加获取子Input的方法。

### 0.2.5
给`MVPModel`增加简易实例化的方法。

### 0.2.4

处理Tableview闪屏、自动滚动的问题。

### 0.2.3

修改`MVPContentCell`的Presenter获取途径，保证CoredataInput可以正常使用`MVPContentCell`的功能。

### 0.2.2

将`CoreDataInput`的fetch加载方式改为懒加载，防止init方法执行于input继承类属性赋值之前导致属性缺失。

### 0.2.1

增加`MVPComplexInput`用于创建复合Input，可以组合不同的Input，每一个Input作为单独section的数据源。

### 0.2.0

1. `MVPView`增加`bindSelector`方法直接用于绑定`MVPPresenter`的方法实现。

主要用于转发 MVPView的 UIViewController LifeCircle方法，例如将`viewWillAppear:`转发给Presenter

```mm
[self mvp_bindSelector:@selector(viewWillAppear:)];
```

2. `MVPView`增加`bindGesture`方法用于绑定手势触发`MVPPresenter`的`- (void)mvp_gestrue:(__kindof UIGestureRecognizer *)gesture`方法。

另外为了与`MVPContentCell`的方法做区分，增加`- (void)mvp_gestrue:(__kindof UIGestureRecognizer*)gesture model:(id<MVPModelProtocol>)model;`用与专门响应ContentCell的手势，这个方法会同时将生成ContentCell的model传过来。

3. `MVPRouter`增加通过URL获取参数的方法。

注册方法名与URL对应
```mm
[self.router regiestTarget:self selector:@selector(testString) asRouter:@"demo://getTestString"];
```

注册全局静态参数
```mm
[self.router regiestTarget:self selector:@selector(testString) asStaticRouter:@"demo://getTestString2"];
```

二者区别是，第一种注册，只会在Router的`valueForRouterURL`方法调用的时候请求，结果是动态的。

```mm
[self.router valueForRouterURL:@"demo://getTestString"];
```

第二种是在注册时就会请求一次数据并全局缓存，此后不再调用数据生成方法，除非重新注册。