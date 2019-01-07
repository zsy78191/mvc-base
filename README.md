# mvc-base
自用代码库

## 版本迭代记录

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