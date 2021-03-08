<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>${title!"列表"}</title>
	[#include "/admin/common/commons.html"]
	[#include "/tenant/common/site.html"]
	[#include "/tenant/default/${config_entity}/component.html"]
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
				<script type="text/x-template" id="my-${config_entity}-list">
					[@${config_entity}ListView /]
				</script>
				<!-- Default box -->

				<!-- 增加页面 -->
				<script type="text/x-template" id="my-${config_entity}-add">
					[@${config_entity}AddView /]
				</script>
				<!-- 更新页面 -->
				<script type="text/x-template" id="my-${config_entity}-update">
					[@${config_entity}UpdateView /]
				</script>
				<script type="text/x-template" id="my-${config_entity}-show">
					[@${config_entity}ShowView /]
				</script>


				<!-- /.box -->
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

	<script type="text/javascript">
		//显示组件开始
		var ${config_entity}ShowConfig = {};
		${config_entity}ShowConfig.template = "#my-${config_entity}-show";
		${config_entity}ShowConfig.methods =config.basicMethod();
		${config_entity}ShowConfig.data = function () {
			return {
				viewModel: {
				},
				activeIndex: "1"
			}
		};

		<#if childView>
		${config_entity}ShowConfig.methods.handleSelect = function (index) {
			console.log(index)
			var selectId = this.selectId;
			if (index == "1") {
				this.$router.replace({ path: '/view/index', query: { id: selectId, activeIndex: 1, time: Math.random() } })
			}
			else if (index == "2") {
				this.$router.replace({ path: '/view/members', query: { id: selectId, activeIndex: 2, time: Math.random() } })
			} else {

			}
		};
        </#if>

		${config_entity}ShowConfig.mounted = function () {
		   <#if childView>
		   	var id = this.$route.query.id;
			var activeIndex = this.$route.query.activeIndex;

			var self = this;
			var data = {};
			data.id = id;
			this.selectId = data.id;
			if (activeIndex) {
				this.activeIndex = activeIndex;
			}
		   <#else>
			var id = this.$route.query.id;
			var self = this;
			var data = {};
			data.id = id;
			this.postData("<#noparse>${siteurl}</#noparse>tenantRest/${config_entity}/view.htm", data, function (res) {
				if (res.code == 0) {
					self.viewModel = res;

				}
			});
			</#if>
		}
		var ${config_entity}ShowView = Vue.component('my-${config_entity}-view', ${config_entity}ShowConfig);
		//显示组件结束		
	</script>
	<script type="text/javascript">
		//添加组件开始
		var ${config_entity}AddConfig = {};
		${config_entity}AddConfig.template = "#my-${config_entity}-add";
		${config_entity}AddConfig.methods = config.basicMethod();
		${config_entity}AddConfig.data = function () {
			return {
				form: {
					<#list bean.fields as item>
					${item.id!}: ''<#sep>,
					</#list>
				},
				rules: {
					   <#list bean.fields as item>
                        <#if item.required>
                        ${item.id}: [
							{ required: true, message: '请输入${item.title!}', trigger: 'blur' }
						]<#sep>,
                        </#if>
                        </#list>
				}
			}
		};
		${config_entity}AddConfig.mounted = function () {
		}
		${config_entity}AddConfig.computed = {};
		<#list bean.fields as item>
              <#if item.option?length gt 2 >
				  ${config_entity}AddConfig.computed.${item.id}Options = function () {
						return this.$store.state.${item.id}Options;
					};
              </#if>
        </#list>


		${config_entity}AddConfig.methods.add = function () {
			var self = this;
			this.$refs["ruleForm"].validate(function(valid){
				if (valid) {
					self.addData();
				} else {
					console.log('error submit!!');
					return false;
				}
			});
		}

		${config_entity}AddConfig.methods.addData = function () {
			var self = this, data = this.form;
			if (this.deforeAddData) {
				this.deforeAddData();
			}
			this.postData("<#noparse>${siteurl}</#noparse>tenantRest/${config_entity}/create.htm", data, function (res) {
				if (res.code == 0) {
					self.$message({
						message: '添加数据成功',
						type: 'success'
					});
					self.$router.go(-1);
				} else {
					self.$message.error(res.msg);
				}
			});
		}
		var  ${config_entity}AddView = Vue.component('add-view', ${config_entity}AddConfig);


	</script>
	<script type="text/javascript">
		//更新组件开始
		var ${config_entity}UpdateConfig = {};
		${config_entity}UpdateConfig.template = "#my-${config_entity}-update";
		${config_entity}UpdateConfig.methods = config.basicMethod();
		${config_entity}UpdateConfig.methods.updateData = function () {
			var self = this;
			this.$refs["ruleForm"].validate(function(valid){
				if (valid) {
					self.updateDataPost();
				} else {
					console.log('error submit!!');
					return false;
				}
			});
		}

		${config_entity}UpdateConfig.methods.updateDataPost = function () {
			var self = this, data = this.form;
			//delete data.${config_entity}Catalog;
			if (this.deforeUpdateData) {
				this.deforeUpdateData();
			}
			this.postData("<#noparse>${siteurl}</#noparse>tenantRest/${config_entity}/update.htm", data, function (res) {
				if (res.code == 0) {
					self.$message({
						message: '修改数据成功',
						type: 'success'
					});
					//window.history.go(-1)
					self.$router.go(-1);
				} else {
					self.$message.error(res.msg);
				}
			});
		}
		${config_entity}UpdateConfig.data = function () {
			return {
				form: {
					<#list bean.fields as item>
					${item.id!}: ''<#sep>,
					</#list>
				},
				rules: {
					   <#list bean.fields as item>
                        <#if item.required>
                        ${item.id}: [
							{ required: true, message: '请输入${item.title!}', trigger: 'blur' }
						]<#sep>,
                        </#if>
                        </#list>
				}
			}
		};

		${config_entity}UpdateConfig.mounted = function () {
			var id = this.$route.query.id;
			var self = this;
			var data = {};
			data.id = id;
			this.postData("<#noparse>${siteurl}</#noparse>tenantRest/${config_entity}/view.htm", data, function (res) {
				if (res.code == 0) {
					self.form = res;
				}
			});
		}
		${config_entity}UpdateConfig.computed = {};
		<#list bean.fields as item>
              <#if item.option?length gt 2 >
				  ${config_entity}UpdateConfig.computed.${item.id}Options = function () {
						return this.$store.state.${item.id}Options;
					};
              </#if>
        </#list>

		var ${config_entity}UpdateView = Vue.component('update-view', ${config_entity}UpdateConfig);
		//更新组件结束
	</script>
	<script type="text/javascript">
		var ${config_entity}ListConfig = {};
		${config_entity}ListConfig.template = "#my-${config_entity}-list";
		${config_entity}ListConfig.methods = config.basicMethod();


		${config_entity}ListConfig.methods.addView = function () {
			this.$router.push({ path: 'add'});
		}
		${config_entity}ListConfig.methods.editView = function (row) {
			var self = this;
			var data = {};
			data.id = row.id;
			this.$router.push({ path: 'update', query: data });

		}

		${config_entity}ListConfig.methods.changeTableSort = function (column) {
			this.searchObject.sortField = column.prop;
			if ("descending" == column.order) {
				this.searchObject.sortMethod = "desc";
			}
			else if ("ascending" == column.order) {
				this.searchObject.sortMethod = "asc";
			}
			else {
				this.searchObject.sortMethod = "";
			}
			this.getSearchList();
		}
		${config_entity}ListConfig.methods.showView = function (row, column, cell, event) {
			if (cell.cellIndex > 0) {
				return;
			}
			var param = {};
			param.id = row.id;
			var self = this;
			this.$router.push({ path: 'view', query: param });

		}

		${config_entity}ListConfig.methods.sizeChange = function (event) {
			this.searchObject.size = event;
			this.getSearchList();
		}
		${config_entity}ListConfig.methods.pageChange = function (index) {
			this.searchObject.no = index;
			this.getSearchList();
		}
		${config_entity}ListConfig.methods.getSearchList = function () {
			this.loading = true;
			var data = this.searchObject, that = this;
			$.post("<#noparse>${siteurl}</#noparse>tenantRest/${config_entity}/search.htm", data, function (result) {
				if (result.code == 0) {
					that.tableData = result;
				}
				setTimeout(function(){
					that.loading = false;
				}, 300)
			});
		}
		${config_entity}ListConfig.methods.search = function () {
			this.searchObject.no = 1;
			this.getSearchList();
		}
		${config_entity}ListConfig.methods.clearData = function () {
			<#if searchs??>
				<#list searchs as item>
					this.searchObject.${item.id} = "";
				</#list>
			</#if >
		}
		${config_entity}ListConfig.methods.deleteData = function (event) {
			this.selectId = event.id;
			this.dialogVisible = true;
		}

		${config_entity}ListConfig.methods.handleClose = function (done) {
			this.dialogVisible = false;
			var self = this;
			if (self.selectId) {
				var params = {};
				params.id = self.selectId;
				this.postData("<#noparse>${siteurl}</#noparse>tenantRest/${config_entity}/delete.htm", params, function (res) {
					if (res.code == 0) {
						self.$message({
							message: '删除数据成功',
							type: 'success'
						});
						self.getSearchList();
					} else {
						self.$message.error(res.msg);
					}
				});
			}

		}

		${config_entity}ListConfig.computed = {};
		<#list bean.fields as item>
              <#if item.option?length gt 2 >
				  ${config_entity}ListConfig.computed.${item.id}Options = function () {
						return this.$store.state.${item.id}Options;
					};
              </#if>
        </#list>

		${config_entity}ListConfig.data = function () {
			return {
				searchObject: {
					no: 1,
					size: 10,
					<#if searchs??>
					    <#list searchs as item>
						${item.id}:''<#sep>,
						</#list>
					</#if>
				},
				dialogVisible: false,
				defaultProps: {
					children: 'children',
					label: 'name'
				},
				loading: false,
				tableData: {},
			}
		};
		${config_entity}ListConfig.methods.showAddView = function () {
			this.$router.push({ path: 'add'});
		};
		${config_entity}ListConfig.mounted = function () {

		}
        ${config_entity}ListConfig.activated = function () {
			this.getSearchList();
		}
		var ${config_entity}ListView = Vue.component('list-${config_entity}-view', ${config_entity}ListConfig);
	</script>

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