
<!-- 增加页面开始 -->
[#macro ${config_entity}AddView]
    <div  class="model-form">
        <el-page-header @back="goBack" content="增加${model!}">
        </el-page-header>
        <div class="model-content">
            <el-form ref="ruleForm" :rules="rules" :model="form" label-width="160px" >
                <el-row :gutter="10">
                    <#list bean.fields as item>
                        <el-col :span="12">
                            <el-form-item label="${item.title!}" size="mini" prop="${item.id!}">
                                <#if item.type='date'>
                                <el-date-picker v-model="form.${item.id!}" type="date"   value-format="yyyy-MM-dd"  placeholder="选择日期">
                                </el-date-picker>
                                <#elseif item.type='el_date_picker'>
                                <el-date-picker v-model="form.${item.id!}" type="date"  value-format="yyyy-MM-dd"  placeholder="选择日期">
                                </el-date-picker>
                                <#elseif item.type='el_date_time_picker'>
                                <el-date-picker v-model="form.${item.id!}" type="datetime" value-format="yyyy-MM-dd HH:mm" placeholder="选择日期">
                                </el-date-picker>
                                <#elseif item.type='el_time_select'>
                                <el-time-select
                                        placeholder="选择时间"
                                        v-model="form.${item.id!}"
                                        :picker-options="{
                                        start: '08:30',
                                        step: '00:15',
                                        end: '18:30'
                                        }">
                                </el-time-select>
                                <#elseif item.type='select'>
                                    <el-select style="width: 100%;"  v-model="form.${item.id!}" filterable clearable
                                            placeholder="请选择">
                                        <el-option v-for="item in ${item.option!}Options" :key="item.id"
                                                :label="item.name" :value="item.id">
                                        </el-option>
                                    </el-select>
                                <#elseif item.type='textarea'>
                                    <el-input v-model="form.${item.id!}" name="${item.id!}" type="textarea"></el-input>
                                <#elseif item.type='el_input_number'>
                                <el-input-number v-model="form.${item.id!}" name="${item.id!}" type="textarea" :min="0" :max="100"></el-input-number>
                                <#elseif item.type='el_cascader'>
                                    <el-cascader
                                            v-model="form.${item.id!}"
                                            :options="options"
                                            @change="handleChange"></el-cascader>
                                <#elseif item.type='el_switch'>
                                    <el-switch
                                            v-model="form.${item.id!}"
                                            active-color="#13ce66"
                                            inactive-color="#ff4949">
                                    </el-switch>
                                <#elseif item.type='el_slider'>
                                    <el-slider v-model="form.${item.id!}"></el-slider>
                                <#elseif item.type='el_rate'>
                                    <el-rate v-model="form.${item.id!}"></el-rate>
                                <#elseif item.type='el_radio_group'>
                                    <el-radio v-model="form.${item.id!}" label="1">备选项</el-radio>
                                    <el-radio v-model="form.${item.id!}" label="2">备选项</el-radio>
                                <#elseif item.type='el_checkbox_group'>
                                    <el-checkbox-group v-model="form.${item.id!}">
                                        <el-checkbox label="复选框 A"></el-checkbox>
                                        <el-checkbox label="复选框 B"></el-checkbox>
                                        <el-checkbox label="复选框 C"></el-checkbox>
                                    </el-checkbox-group>
                                <#elseif item.type='el_upload'>
                                    <avatar  v-model="form.${item.id!}"  ></avatar>
                                <#elseif item.type='image'>
                                <avatar  v-model="form.${item.id!}"  ></avatar>
                                <#elseif item.type='dictionary'>
                                <nb-select catalog="${item.id!}" v-model="form.${item.id!}"></nb-select>
                                <#else>
                                    <el-input v-model="form.${item.id!}" name="${item.id!}">
                                    </el-input>
                                </#if>
                            </el-form-item>
                        </el-col>
                    </#list>
                </el-row>
                <el-row style="text-align: right;">
                    <el-button @click="goBack">取消</el-button>
                    <el-button type="primary" @click="add">确定</el-button>
                </el-row>
            </el-form>
        </div>
    </div>
[/#macro]

[#macro ${config_entity}AddConfig]
<script type="text/x-template" id="my-${config_entity}-add">
	[@${config_entity}AddView /]
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
[/#macro]

<!-- 增加页面结束 -->