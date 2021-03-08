[#macro ${config_entity}ListView]
    <div>
        <el-dialog title="提示" :visible.sync="dialogVisible" width="30%">
            <span>确认要删除该条数据吗?</span>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="handleClose">确 定</el-button>
            </span>
        </el-dialog>
        <div class="search">
            <el-form label-width="${bean.searchWidth!80}px">
                <el-row>
                    <#if searchs??>
                    <#list searchs as item>
                    <el-col :span="6" style="padding: 0 8px;">
                        <el-form-item label="${item.title}">
                            <#if item.type='date'>
                            <el-date-picker value-format="yyyy-MM-dd" size="small" v-model="searchObject.${item.id!}" type="date" placeholder="选择日期">
                            </el-date-picker>
                            <#elseif item.type='select'>
                            <el-select size="small" style="width: 100%;"  v-model="searchObject.${item.id!}" filterable clearable
                                       placeholder="请选择">
                                <el-option v-for="item in ${item.id!}Options" :key="item.id"
                                           :label="item.name" :value="item.id">
                                </el-option>
                            </el-select>
                            <#elseif item.type='textarea'>
                            <el-input v-model="searchObject.${item.id!}" size="small" name="${item.id!}" type="textarea"></el-input>
                            <#else>
                            <el-input v-model="searchObject.${item.id!}" size="small" placeholder="${item.placeholder}" name="${item.id!}">
                            </el-input>
                        </#if>
                        </el-form-item>
                    </el-col>
                </#list>
            </#if>

            <el-col :span="${leftSize!'6'}" style="padding: 0 10px;margin-top: 5px;">
                <el-row type="flex" justify="end">
                    <el-button size="small" type="primary" @click="search">搜索</el-button>
                    <el-button size="small" plain @click="clearData">清除条件</el-button>
                </el-row>
            </el-col>
            </el-row>
            </el-form>
        </div>
        <div class="data-content">
            <div  class="tool-add">
                <el-button type="primary" size="small" @click="addView">新增</el-button>
            </div>

            <el-table v-loading="loading" :data="tableData.list"  @cell-click="showView" @sort-change="changeTableSort" style="width: 100%;font-size: 12px;">
                <#if bean.grids??>
                    <#list bean.grids as item>
                        <el-table-column label="${item.title}"

                                        prop="${item.id!}${item.extName!}"
                        <#if item.sort>sortable="custom" </#if>
                        <#if item.width?length lt 4 > width="${item.width!}"  </#if>
                        >
                        </el-table-column>
                    </#list>
                </#if>
                <el-table-column width="160" align="center" fixed="right" label="操作">
                    <template slot-scope="scope">
                        <el-button type="primary" size="mini" @click="editView(scope.row)">编辑
                        </el-button>
                        <el-button type="danger" size="mini"  style="cursor: pointer;"
                                @click="deleteData(scope.row)">删除</el-button>
                    </template>
                </el-table-column>
                </el-table>

            <div class="page">
                <el-pagination background :current-page="searchObject.no" :page-sizes="[10, 20, 50, 100]"
                            :page-size="tableData.size" :pager-count="5"
                            layout="total, sizes, prev, pager, next, jumper" :page-count="tableData.totalPage"
                            :total="tableData.total" @size-change="sizeChange" @current-change="pageChange">
                </el-pagination>
            </div>
        </div>
    </div>
[/#macro]


[#macro ${config_entity}AddView]
    <div  class="model-form">
        <el-page-header @back="goBack" content="增加${model!}">
        </el-page-header>
        <div class="model-content">
            <el-form ref="ruleForm" :rules="rules" :model="form" label-width="160px" >
                <el-row :gutter="10">
                 
                </el-row>
                <el-row style="text-align: right;">
                    <el-button @click="goBack">取消</el-button>
                    <el-button type="primary" @click="add">确定</el-button>
                </el-row>
            </el-form>
        </div>
    </div>
[/#macro]

[#macro ${config_entity}UpdateView]
    <div class="model-form">
        <el-page-header @back="goBack" content="更新${model!}">
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
                    <el-button type="primary" @click="updateData">确定</el-button>
                </el-row>
            </el-form>
        </div>
    </div>
[/#macro]

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
                    <div v-html="viewModel.${item.id!}${item.extName!}">></div>
                </el-form-item>
            </el-col>
            </#list>
             </#if>
        </el-form>
    </#if>

</div>
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