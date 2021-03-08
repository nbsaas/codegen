<!DOCTYPE html>
<html lang="zh-CN">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>${title!"列表"}</title>
	[#include "/admin/common/commons.html"]
	[#include "/tenant/common/site.html"]
	[#include "/tenant/default/${config_entity}/componentAdd.html"]
	[#include "/tenant/default/${config_entity}/componentList.html"]
	[#include "/tenant/default/${config_entity}/componentUpdate.html"]
	[#include "/tenant/default/${config_entity}/componentShow.html"]

	[@baseHead /]
	<script type="text/javascript"></script>
</head>

<body class="hold-transition skin-blue sidebar-mini">
	<!-- Site wrapper -->
	<div class="wrapper">

		<header class="main-header">
			<!-- Header Navbar: style can be found in header.less -->
			[#include "/admin/common/nav.html"]
		</header>

		<!-- =============================================== -->

		<!-- Left side column. contains the sidebar -->
		<aside class="main-sidebar">
			<!-- sidebar: style can be found in sidebar.less -->
			<section class="sidebar">
				[@user_panel /]
				<!-- search form -->
				[@sidebar_form /]
				<!-- /.search form -->
				<!-- sidebar menu: : style can be found in sidebar.less -->
				<ul class="sidebar-menu" data-widget="tree">
					<li class="header">主面板</li>
					[@menustag id=1]
					[#list list as item]
					[@menu item "${menus!''}"]
					[/@menu]
					[/#list]
					[/@menustag]
				</ul>
			</section>
			<!-- /.sidebar -->
		</aside>

		<!-- =============================================== -->

		<!-- Content Wrapper. Contains page content -->
		<div class="content-wrapper" id="app"   v-cloak  >
			<!-- Content Header (Page header) -->
			<section class="content-header">
				<!-- 导航 -->
				<div class="navigation">
					<i>首页</i> <span>${title!"列表"}</span>
				</div>
			</section>
			<!-- Main content -->
			<section class="content">
				<keep-alive>
					<router-view v-if="$route.meta.keepAlive">
					</router-view>
				</keep-alive>
				<router-view v-if="!$route.meta.keepAlive">
				</router-view>
				<!-- Default box -->
			</section>


			<!-- /.content -->
		</div>
		<!-- /.content-wrapper -->

		[#include "/admin/common/footer.html"]

		<!-- Control Sidebar -->
		[#include "/admin/common/aside.html"]

		<!-- /.control-sidebar -->
		<!-- Add the sidebar's background. This div must be placed
     immediately after the control sidebar -->
		<div class="control-sidebar-bg"></div>
	</div>
	<!-- ./wrapper -->
	[@baseScript /]
	<#if componentState>
		[#include "/tenant/default/common/component.html" /]
		 <#list components as item>
		 [@${item} /]
		 </#list>
	</#if>

	<script type="text/javascript">
		var config = {};

		config.methods = {};

		[@configBasicVue /]

		config.methods.goBack = function () {
			this.$router.go(-1);
		}
		config.basicMethod=function(){
		   var result={};
		   result.postData=config.methods.postData;
           result.postJsonData=config.methods.postJsonData;
           result.goBack=config.methods.goBack;
           return result;
		}

		<#list bean.fields as item>
		<#if item.option?length gt 2 >
		config.methods.load${item.id?cap_first}Options= function(){
				var self=this;
				var param = {};
				param.sortMethod = "asc";
				param.sortField = "id";
				param.level =2;
				param.size =500;
				$.post("<#noparse>${siteurl}</#noparse>tenantRest/${item.id?lower_case}/list.htm", param, function (result) {
					if (result.code == 0) {
						self.$store.commit('update${item.id?cap_first}Options', result.list);
					}
				});
		}

		</#if>
		</#list>

	</script>

	
    
	[@${config_entity}AddConfig /]
	[@${config_entity}ListConfig /]
	[@${config_entity}ShowConfig /]
	[@${config_entity}UpdateConfig /]

	<#if childView>
	[@child${config_entity?cap_first}Config /]
    </#if>

	<script type="text/javascript">
	
		// 3. 创建 router 实例，然后传 `routes` 配置
		// 你还可以传别的配置参数, 不过先这么简单着吧。
		var appConfig = {};
		appConfig.el = "#app";


       <#if childView>
		   const routes = [
				{ path: '/view',name: "${config_entity}ShowView", component: ${config_entity}ShowView, props: true, children: [
                    { path: "/view/index", name: "child${config_entity?cap_first}ShowView", component: child${config_entity?cap_first}ShowView },
					{ path: "/", component: child${config_entity?cap_first}ShowView }
				]
				 },
				{ path: '/add',name: "${config_entity}AddView", component: ${config_entity}AddView , props: true },
				{ path: '/update', name: "${config_entity}UpdateView", component: ${config_entity}UpdateView, props: true },
				{ path: '/',name: "${config_entity}ListView", component: ${config_entity}ListView , props: true , meta: {
						keepAlive: true, //此组件不需要被缓存
					}
				}
			]
        <#else>
			const routes = [
				{ path: '/view',name: "${config_entity}ShowView", component: ${config_entity}ShowView, props: true },
				{ path: '/add',name: "${config_entity}AddView", component: ${config_entity}AddView , props: true },
				{ path: '/update', name: "${config_entity}UpdateView", component: ${config_entity}UpdateView, props: true },
				{ path: '/',name: "${config_entity}ListView", component: ${config_entity}ListView , props: true , meta: {
						keepAlive: true, //此组件不需要被缓存
					}
				}
			]
		</#if>



		const router = new VueRouter({
			routes:routes // (缩写) 相当于 routes: routes
		})

		var store = new Vuex.Store({
			state: {
				count: 0,
				<#list bean.fields as item>
                    <#if item.option?length gt 2 >
                     ${item.id}Options: []<#sep>,
                     </#if>
                 </#list>
			},
			mutations: {
				increment:function(state) {
					state.count++
				},
				<#list bean.fields as item>
                    <#if item.option?length gt 2 >
                    update${item.id?cap_first}Options:function(state, obj) {
					   state.${item.id}Options = obj;
				     }<#sep>,
                     </#if>
                 </#list>

			}
		})

		appConfig.router = router;

		appConfig.store = store;
		appConfig.methods = config.methods;
		appConfig.mounted = function () {
			<#list bean.fields as item>
            <#if item.option?length gt 2 >
             this.load${item.id?cap_first}Options();
            </#if>
            </#list>
		}
		var vm = new Vue(appConfig);

	</script>

</body>

</html>