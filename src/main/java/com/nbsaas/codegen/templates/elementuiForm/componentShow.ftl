
[#macro ${config_entity}ShowView]
<div  class="model-form">
    <el-page-header @back="goBack" content="详情">
    </el-page-header>

    <#if childView>
        <el-menu :default-active="activeIndex" class="el-menu-demo" mode="horizontal" @select="handleSelect">
            <el-menu-item index="1">
                ${model!}详情
            </el-menu-item>
        </el-menu>
        <div>
            <router-view></router-view>
        </div>
     <#else>
        <div class="form-title">详细信息</div>
        <el-form class="viewForm" label-width="${bean.viewWidth!80}px">
            <#if bean.fields??>
            <#list bean.fields as item>
            <el-col :span="12">
                <el-form-item label="${item.title}">
                    <div v-html="viewModel.${item.id!}${item.extName!}"></div>
                </el-form-item>
            </el-col>
            </#list>
             </#if>
        </el-form>
    </#if>

</div>
[/#macro]
[#macro ${config_entity}ShowConfig]
<script type="text/x-template" id="my-${config_entity}-show">
    [@${config_entity}ShowView /]
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
[/#macro]


<#if childView>

[#macro child${config_entity?cap_first}View]
    <div >
        <el-form class="viewForm" label-width="${bean.viewWidth!100}px">
            <#if bean.fields??>
            <#list bean.fields as item>
            <el-col :span="12">
                <el-form-item label="${item.title}">
                    <div v-html="viewModel.${item.id!}${item.extName!}">></div>
                </el-form-item>
            </el-col>
            </#list>
            </#if>
        </el-form>
    </div>
 [/#macro]

[#macro child${config_entity?cap_first}Config]
    <script type="text/x-template" id="child-${config_entity}-show">
        [@child${config_entity?cap_first}View /]
    </script>
    <script type="text/javascript">

        var child${config_entity?cap_first}ShowConfig = {};
        child${config_entity?cap_first}ShowConfig.template = "#child-${config_entity}-show";
        child${config_entity?cap_first}ShowConfig.methods = config.basicMethod();
        child${config_entity?cap_first}ShowConfig.data = function () {
            return {
                viewModel: {
                }
            }
        };
        child${config_entity?cap_first}ShowConfig.mounted = function () {
            var id = this.$route.query.id;
            var self = this;
            var data = {};
            data.id = id;
            this.postData("<#noparse>${siteurl}</#noparse>tenantRest/${config_entity}/view.htm", data, function (res) {
                if (res.code == 0) {
                    self.viewModel = res;

                }
            });
        }
        var child${config_entity?cap_first}ShowView = Vue.component('child-${config_entity}-show', child${config_entity?cap_first}ShowConfig);
    </script>
[/#macro]

</#if>