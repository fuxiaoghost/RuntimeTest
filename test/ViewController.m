//
//  ViewController.m
//  test
//
//  Created by Kirn on 9/22/15.
//  Copyright © 2015 北京易客信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()<UITableViewDelegate>{
    NSString *privateName;
    NSString *privateName1;
    NSString *privateName2;
    NSString *privateName3;
    NSString *privateName4;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *name1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // runtime 注解
    
    /* Working with Classes */
    //[self Working_with_Classes];
    
    /* Adding Classes */
    //[self Adding_Classes];
    
    /* Working with Instances */
    //[self Working_with_Instances];
    
    /* Obtaining Class Definitions */
    //[self Obtaining_Class_Definitions];
    
    /* Working with Instance Variables */
    //[self Working_with_Instance_Variables];
    
    /* Sending Messages */
    //[self Sending_Messages];
    
    /* Working with Methods */
    //[self Working_with_Methods];
    
    /* Working with Libraries */
    //[self Working_with_Libraries];
    
    /* Working with Selectors */
    //[self Working_with_Selectors];
    
    /* Working with Protocols */
    //[self Working_with_Protocols];
    
    /* Working with Properties */
    [self Working_with_Properties];
}

- (void)Working_with_Classes{
    // 获取类名
    const char *className;
    className = class_getName([ViewController class]);
    NSLog(@"%s",className);
    
    // 获取superclass
    Class cls = class_getSuperclass([ViewController class]);
    NSLog(@"%@",cls);
    
    // 判断是否为metaclass
    BOOL isMetaCls = class_isMetaClass([ViewController class]);
    NSLog(@"%d",isMetaCls);
    
    // 获取类的实例大小
    size_t size = class_getInstanceSize([ViewController class]);
    NSLog(@"%ld",size);
    
    // 获取类的实例变量
    privateName = @"private name";
    Ivar ivar = class_getInstanceVariable([ViewController class], "privateName");
    id viewIvar = object_getIvar(self, ivar);
    NSLog(@"%@",viewIvar);
    
    // 获取类变量!!!!
    
    // 获取类实例变量列表
    unsigned int ivarsCount;
    Ivar *ivars = class_copyIvarList([ViewController class], &ivarsCount);
    while (*ivars) {
        NSLog(@"%s",ivar_getName(*ivars));
        ivars++;
    }
    
    // 获取类属性
    self.name = @"name";
    objc_property_t property = class_getProperty([ViewController class], "name");
    const char *propertyName = property_getName(property);
    NSLog(@"%s",propertyName);
    
    // 获取属性列表
    unsigned int propertyCount;
    objc_property_t *propertys = class_copyPropertyList([ViewController class], &propertyCount);
    while (*propertys) {
        NSLog(@"%s",property_getName(*propertys));
        propertys++;
    }
    
    // 类添加方法
    class_addMethod([ViewController class], @selector(say:), (IMP)say, "i@:@");
    [[ViewController alloc] performSelector:@selector(say:) withObject:@"hello..."];
    
    // 获取类实例方法
    Method method = class_getInstanceMethod([ViewController class], @selector(say:));
    NSLog(@"%s",method_getName(method));
    
    // 获取类方法
    Method cmethod = class_getClassMethod([ViewController class], @selector(classSay));
    NSLog(@"%s",method_getName(cmethod));
    
    // 获取类实例方法列表
    unsigned int methodCont;
    Method *methods = class_copyMethodList([ViewController class], &methodCont);
    NSLog(@"method list ...... begin");
    while (*methods) {
        NSLog(@"%s",method_getName(*methods));
        methods++;
    }
    NSLog(@"method list ...... end");
    
    // 类替换方法
    class_replaceMethod([ViewController class], @selector(say:), (IMP)replaceSay, "i@:@");
    [[ViewController alloc] performSelector:@selector(say:) withObject:@"hello..."];
    
    // 获取类实例方法的IMP
    IMP imp = class_getMethodImplementation([ViewController class], @selector(say:));

    // 是否能响应方法
    BOOL responds = class_respondsToSelector([ViewController class], @selector(say:));
    NSLog(@"%d",responds);
    
    // 添加protocol
    //class_addProtocol([ViewController class], )
    
    
    // 添加属性
    objc_property_attribute_t type = { "T", "@\"NSString\"" };
    objc_property_attribute_t ownership = { "C", "" }; // C = copy
    objc_property_attribute_t backingivar  = { "V", "_name2" };
    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
    class_addProperty([ViewController class], "name2", attrs, 3);
    
    // protocol 列表
    unsigned int protocolCount;
    __unsafe_unretained Protocol **protocols = class_copyProtocolList([ViewController class], &protocolCount);
    for(int i = 0 ;i < protocolCount;i++){
        NSLog(@"%s", protocol_getName(*(protocols+i)));
    }
    
    // 获取版本
    class_setVersion([ViewController class], 3);
    int version = class_getVersion([ViewController class]);
    NSLog(@"%d",version);
    
}

- (void)Adding_Classes{
    // 添加新类
    Class People = objc_allocateClassPair([NSObject class], "People", 0);
    objc_registerClassPair(People);
    id people = [[People alloc] init];
    NSLog(@"new class: %@ superclass: %@", people, [people superclass]);

    
}

- (void)Working_with_Instances{
    // 拷贝对象
    //id newCopy = object_copy(self,class_getInstanceSize([ViewController class]));
    
    // 实例变量值
    privateName = @"private name";
    Ivar ivar = class_getInstanceVariable([ViewController class], "privateName");
    
    NSLog(@"%@",object_getIvar(self, ivar));
    
    // 实例变量赋值
    object_setIvar(self, ivar, @"new private name");
    NSLog(@"%@",object_getIvar(self, ivar));
    
    // 获取类
    NSLog(@"%@", object_getClass(self));
    
    // 获取类名
    NSLog(@"%s",object_getClassName(self));
}

- (void)Obtaining_Class_Definitions{
    // 获取所有注册的类 
    int numClasses;
    Class *classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0 )
    {
        classes = (Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        // objc_copyClassList
        free(classes);
    }
    while (*classes) {
        NSLog(@"%s",class_getName(*classes));
        classes++;
    }
    
    // 查看类描述
    NSLog(@"%@",objc_lookUpClass("ViewController"));
    
    // 通过类名获取Class
    NSLog(@"%@",objc_getClass("ViewController"));
    
    // 获取MetaClass
    NSLog(@"%@",objc_getMetaClass("ViewController"));
}

- (void)Working_with_Instance_Variables{
    Ivar ivar = class_getInstanceVariable([ViewController class], "privateName");
    
    // 获取实例变量名
    NSLog(@"%s",ivar_getName(ivar));
    
    // 获取实例变量类型
    NSLog(@"%s",ivar_getTypeEncoding(ivar));
    
}

- (void)Sending_Messages{
    // 发送消息 id objc_msgSend(id self, SEL op, ...)
    ((void (*)(id,SEL,id))objc_msgSend)(self,@selector(message:),@"message send");
}

- (void)Working_with_Methods{
    Method method = class_getInstanceMethod([ViewController class], @selector(message:));
    Method methodRepace = class_getInstanceMethod([ViewController class], @selector(replaceMessage:));
    
    // 方法调用 id method_invoke(id receiver, Method m, ...)
    ((void(*)(id,Method,id))method_invoke)(self,method,@"method invoke");
    
    // 获取方法名
    NSLog(@"%s",method_getName(method));
    
    // 获取方法IMP
    method_getImplementation(method);
    
    // 获取方法参数和返回值类型编码 Returns a string describing a method's parameter and return types.
    NSLog(@"%s", method_getTypeEncoding(method));
    
    // 获取方法返回值类型编码 void method_getReturnType( Method method, char *dst, size_t dst_len)
    NSLog(@"%s",method_copyReturnType(method));
    
    // 获取方法参数类型编码 void method_getArgumentType( Method method, unsigned int index, char *dst, size_t dst_len)
    NSLog(@"%s",method_copyArgumentType(method, 0));
    
    // 获取方法参数个数
    NSLog(@"%d",method_getNumberOfArguments(method));
    
    // 获取方法描述
    struct objc_method_description *method_desc = method_getDescription(method);
    
    // 设置Method的IMP(交互)
    IMP imp1 = method_getImplementation(method);
    IMP imp2 = method_getImplementation(methodRepace);
    method_setImplementation(method, imp2);
    method_setImplementation(methodRepace, imp1);
    
    // 交换IMP
    method_exchangeImplementations(method, methodRepace);
}

- (void)Working_with_Libraries{
    // Returns the names of all the loaded Objective-C frameworks and dynamic libraries.
    unsigned int imageCount;
    const char **imagenames = objc_copyImageNames(&imageCount);
    if (**imagenames) {
        NSLog(@"%s",*imagenames);
        imagenames++;
    }
    
    // Returns the name of the dynamic library a class originated from.
    NSLog(@"%s",class_getImageName([ViewController class]));
    
    // Returns the names of all the classes within a specified library or framework.
    // const char **objc_copyClassNamesForImage(const char *image, unsigned int *outCount)
}

- (void)Working_with_Selectors{
    // 获取方法名
    NSLog(@"%s",sel_getName(@selector(message:)));
    
    // 注册方法名 == sel_getUid
    SEL sel = sel_registerName("message:");
    NSLog(@"%s",sel);
    
    // 判断方法是否相同
    NSLog(@"%d",sel_isEqual(sel, sel_getName(@selector(message:))));
}

- (void)Working_with_Protocols{
    // 通过名字获取已存在的Protocol
    Protocol *protocol = objc_getProtocol("UITableViewDelegate");
    
    // 获取所有的Protocol
    unsigned int protocolCount;
    __unsafe_unretained Protocol **protocols = objc_copyProtocolList(&protocolCount);
    for(int i = 0 ;i < protocolCount;i++){
        NSLog(@"%s", protocol_getName(*(protocols+i)));
    }
    
    // 生成Protocol
    Protocol *newProtocol = objc_allocateProtocol("ViewControllerDelegate");
    
    // 注册protocol
    objc_registerProtocol(newProtocol);
    
    // protocol 添加 方法描述
    //void protocol_addMethodDescription(Protocol *proto, SEL name, const char *types, BOOL isRequiredMethod, BOOL isInstanceMethod)
    
    
    // Adds a registered protocol to another protocol that is under construction.
    // void protocol_addProtocol(Protocol *proto, Protocol *addition)
    // The protocol you want to add to (proto) must be under construction—allocated but not yet registered with the Objective-C runtime. The protocol you want to add (addition) must be registered already.
    
    //Adds a property to a protocol that is under construction.
    //void protocol_addProperty(Protocol *proto, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount, BOOL isRequiredProperty, BOOL isInstanceProperty)
    
    // 获取协议名
    NSLog(@"%s",protocol_getName(protocol));
    
    // 协议是否一样
    protocol_isEqual(protocol, newProtocol);
    
    
    // 获取协议的方法列表
    unsigned int methodCount;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, NO, YES, &methodCount);
    for (int i =0; i < methodCount; i++) {
        NSLog(@"%s",(*(methods+i)).name);
    }
    
    
    
    // 获取协议制定方法
    struct objc_method_description method = protocol_getMethodDescription(protocol, @selector(tableView:willSelectRowAtIndexPath:), NO, YES);
    NSLog(@"%s",method.name);
    
    // 获取协议属性列表
    unsigned int propertyCount;
    objc_property_t *properties = protocol_copyPropertyList(protocol, &propertyCount);
    while (properties) {
        NSLog(@"%s",property_getName(*properties));
        properties++;
    }
    
    // 获取指定property
    //objc_property_t protocol_getProperty(Protocol *proto, const char *name, BOOL isRequiredProperty, BOOL isInstanceProperty)
}

- (void)Working_with_Properties{
    objc_property_t property = class_getProperty([ViewController class], "name");
    
    // 获取属性名
    NSLog(@"%s",property_getName(property));
    
    // 获取属性类型
    NSLog(@"%s",property_getAttributes(property));
    
    
}

- (void)message:(NSString *)message{
    NSLog(@"%@",message);
}

- (void)replaceMessage:(NSString *)message{
    NSLog(@"replace:%@",message);
}

+ (id)classSay{
    return nil;
}

int say(id self, SEL _cmd, NSString *str) {
    NSLog(@"%@", str);
    return 100;//随便返回个值
}

int replaceSay(id self, SEL _cmd, NSString *str){
    NSLog(@"replace:%@",str);
    return 100;
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
