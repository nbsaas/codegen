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
                    <#if item.show>
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
                    </#if>
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
[#macro ${config_entity}ListConfig]
<script type="text/x-template" id="my-${config_entity}-list">
	[@${config_entity}ListView /]
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
[/#macro]