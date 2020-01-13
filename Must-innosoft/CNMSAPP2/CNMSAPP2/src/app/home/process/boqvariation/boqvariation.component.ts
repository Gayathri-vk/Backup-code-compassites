import { Component, OnInit, ElementRef, ViewChild } from '@angular/core';
import { ProcessService } from '../process.service';
import { ProjectMaster } from '../projectdetails/projectdetails';
import 'dhtmlx-gantt';
import { TaskService } from '../boqdetails/task.service';
import { count } from 'rxjs/operators';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguModal, NguModalService } from '@ngu/modal';
import { NguAlertService } from '@ngu/alert';
import { SubItemMasterDetails, TaskV, GanttStep } from './boqvariation';
import { ProjectDescriptionDetails } from '../boqdetails/boqdetails';
@Component({
  selector: 'app-boqvariation',
  templateUrl: './boqvariation.component.html',
  styleUrls: ['./boqvariation.component.scss'],
  providers: [TaskService]
})
export class BoqvariationComponent implements OnInit {
  _storeDropdown: { [x: string]: any } = {};
  ganttForm: FormGroup;
  countval = 0;
  sdate: string;
  subchk: string;
  loc: string;
  taskId: any;
  mainchk: string;
  newTask: number;
  MainItemMasterDet: SubItemMasterDetails[];
  // projectList1: ProjectMaster[];
  projectList: any[];
  sampleText: NguModal;
  tasklist: TaskV[];
  chkpro = 0;
  ProjectDescriptionDet: ProjectDescriptionDetails[];
  @ViewChild('gantt_here')
  ganttContainer: ElementRef;
  @ViewChild('myform')
  myform: ElementRef;

  connection;
  constructor(
    private ps: ProcessService,
    private taskService: TaskService,
    private fb: FormBuilder,
    private modal: NguModalService,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.getdescription(1);
    this.getvaraitionDet();

    this.getboqItem(1);
    this.ganttConfig();
    this.initGantt();

    this.renderer();

    this.initForm();
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '400px', lg: '400px' }
    };
  }
  initForm() {
    this.ganttForm = this.fb.group({
      id: '',
      location: '',
      mainitem: '',
      locationname: '',
      mainitemname: 'VARIATIONS',
      subitem: '',
      parent: '',
      subsubitem: '',
      boq: '',
      task: '',
      unit: '',
      qty: 0,
      urate: 0,
      start_date: '',
      end_date: '',
      duration: '',
      step: 0
    });
  }

  renderer() {
    gantt.render();
  }
  getvaraitionDet() {
    this.ps.getVaraitionDet().subscribe(res => {
      console.log(res);
      this.MainItemMasterDet = res;
      this.dropdownToObj(
        this.MainItemMasterDet,
        'SubItemId',
        'SubItemName',
        'subItem'
      );
    });
  }
  getdescription(id) {
    this.ps.getDescription(id).subscribe(res => {
      console.log(res);
      this.ProjectDescriptionDet = res;
      this.dropdownToObj(
        this.ProjectDescriptionDet,
        'Id',
        'Description',
        'location'
      );
    });
  }

  private getboqItem(id) {
    let data = [];
    this.ps.getBoqVarItem(id).subscribe(res => {
      this.tasklist = res;
      const task = this.tasklist;
      data = res || [];
      gantt.unselectTask();
      gantt.clearAll();
      gantt.parse({ data });
      this.countval = data.length;
      if (data.length > 0) {
        this.chkpro = 1;
      }
    });
  }
  private initGantt() {
    gantt.attachEvent('onTaskDrag', (id, mode, task, original) => {
      const formatFunc = gantt.date.date_to_str('%d/%m/%Y');
      if (
        formatFunc(task.start_date) === formatFunc(gantt.getState().min_date)
      ) {
        gantt.getState().min_date = gantt.date.add(
          gantt.getState().min_date,
          -1,
          'day'
        );
        gantt.render();
        gantt.showDate(gantt.getState().min_date);
      } else if (
        formatFunc(task.end_date) === formatFunc(gantt.getState().max_date)
      ) {
        gantt.getState().max_date = gantt.date.add(
          gantt.getState().max_date,
          2,
          'day'
        );
        gantt.render();
        gantt.showDate(gantt.getState().max_date);
      }
    });

    gantt.attachEvent('onAfterTaskAdd', (id, item) => {});
    gantt.attachEvent('onGridResize', function(old_width, new_width) {
      document.getElementById('width_placeholder').innerText = new_width;
    });

    gantt.attachEvent('onAfterTaskUpdate', (id, item) => {
      this.taskService.update(this.serializeTask(item)).then(res => {
        console.log(res);
        gantt.refreshData();
      });
    });

    this.loc = '';
    this.newTask = 0;
    this.mainchk = '';
    this.sdate = '';

    gantt.attachEvent('onTaskCreated', task => {
      this.newTask = 1;
      return true;
    });

    gantt.attachEvent('onAfterTaskAdd', (id, item) => {
      this.newTask = 0;
    });
    this.taskId = null;

    gantt.showLightbox = id => {
      this.taskId = id;
      console.log(this.taskId);
      let task = null;
      task = gantt.getTask(id);
      const cond = task.parent;
      if (!cond) {
        if (this.chkpro === 0) {
          this.chkpro = 1;
          task.ProjectId = 0;
          this.loc = 'l';
          task.text = 'All';
          task.locationId = 0;
          task.mainItemId = '0';
          task.name = 'VARIATIONS';
          task.subitem = '';
          task.subsubitem = '';
          task.boq = 'VARIATIONS';
          task.task = 'VARIATIONS';
          task.unit = '';
          task.qty = 0;
          task.urate = 0;
          task.tcost = 0;
          const currentDate = new Date();
          task.start_date = currentDate;
          task.end_date = currentDate;
          const diff = task.start_date.valueOf() - task.end_date.valueOf();
          task.duration = diff + 1;
          task.dep = '';
          task.step = GanttStep.project;
          gantt.addTask(task, task.parent);
          this.ganttForm.patchValue({
            id: task.id,
            location: task.locationId,
            locationname: task.text,
            mainitem: 0,
            mainitemname: '',
            // parent: 0,
            start_date: task.start_date,
            end_date: task.end_date,
            duration: task.duration
          });
          this.submit();
          return;
        } else {
          gantt.deleteTask(this.taskId);
          this.alert.open({
            heading: 'Warring !!!',
            msg: 'Add Not Possible',
            type: 'danger',
            duration: 5000
          });
          return;
        }
      } else {
        const countva = <TaskV>gantt.getTask(task.parent);
        this.countval = <GanttStep>countva.step;

        switch (this.countval) {
          case 0:
            this.countval = this.countval + 1;
            this.ganttForm.patchValue({
              location: countva.locationId,
              parent: countva.id,
              mainitem: 'VARIATIONS',
              id: task.id
            });
            break;
          case 1:
            this.ganttForm.patchValue({
              location: countva.locationId,
              parent: countva.id,
              mainitem: 'VARIATIONS',
              id: task.id
            });
            break;
          case 2:
            this.ganttForm.patchValue({
              location: countva.locationId,
              mainitem: 'VARIATIONS',
              subitem: countva.mainItemId,
              start_date: countva.start_date,
              end_date: countva.end_date,
              parent: task.parent,
              id: task.id
            });

            break;
          // case 3:
          //   this.ganttForm.patchValue({
          //     location: countva.locationId,
          //     mainitemname: 'VARIATIONS',
          //     subitem: countva.subitem,
          //     start_date: countva.start_date,
          //     end_date: countva.end_date,
          //     parent: task.parent,
          //     id: task.id
          //   });

          //   break;
          case 3: {
            gantt.deleteTask(this.taskId);
            this.alert.open({
              heading: 'Warring !!!',
              msg: 'Add Not Possible',
              type: 'danger',
              duration: 5000
            });
            return;
          }
        }

        this.modal.open(this.sampleText.id);
      }
    };
    gantt.hideLightbox = () => {
      this.modal.close(this.sampleText.id);

      this.taskId = null;
      this.newTask = null;
    };
  }
  save() {
    let task: TaskV;
    task = gantt.getTask(this.taskId);
    const data = this.ganttForm.value;
    this.ganttForm.value.id = task.id;
    task.ProjectId = '1';
    task.locationId = data.location || '';
    task.text = this._storeDropdown.location[data.location] || '';
    task.name = data.mainitem || '';
    task.mainItemId = data.subitem || '';
    task.subitem = this._storeDropdown.subItem[data.subitem] || '';
    task.subsubitem = data.subsubitem || '';
    task.boq = data.boq || '';
    task.task = data.task || '';
    task.unit = data.unit || '';
    task.qty = data.qty || 0;
    task.urate = data.urate || 0;
    task.tcost = task.urate * task.qty;
    const currentDate = new Date();
    task.start_date =
      data.start_date ||
      new Date(
        currentDate.getFullYear(),
        currentDate.getMonth(),
        currentDate.getDay() - 1
      );
    task.end_date = data.end_date || currentDate;

    task.duration = data.duration;

    task.dep = '0';
    task.step = this.countval + 1;
    this.ganttForm.patchValue({
      id: task.id,
      start_date: task.start_date,
      end_date: task.end_date,
      duration: task.duration,
      step: task.step,
      locationname: task.text,
      mainitemname: task.name,
      subitem: task.subitem,
      mainitem: task.mainItemId,
      parent: task.parent
    });
    console.log(this._storeDropdown.location);
    console.log(task);
    this.submit(task);
  }

  cancel() {
    let task = null;
    task = gantt.getTask(this.taskId);
    // this.countval--;
    console.log(task);
    if (this.newTask) {
      gantt.deleteTask(task.id);
    }
    gantt.hideLightbox();
  }

  remove() {
    // this.countval--;
    gantt.deleteTask(this.taskId);
    gantt.hideLightbox();
  }

  private ganttConfig() {
    const resourceConfig = {
      scale_height: 30
    };
    const config = {
      xml_date: '%Y-%m-%d %H:%i',
      columns: [
        {
          name: 'boqrefId',
          label: 'Id',
          width: 100,
          resize: true,
          type: gantt.config.types.project,
          tree: true
        },
        { name: 'text', label: 'Loation', width: '*', resize: true },
        {
          name: 'name',
          label: 'Main Item',
          resize: true,
          width: 80,
          align: 'center'
        },
        {
          name: 'subitem',
          label: 'Sub Item',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'subsubitem',
          label: 'Sub Sub Item',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'boq',
          label: 'BOQ Ref',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'task',
          label: 'Task',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'unit',
          label: 'Unit',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'qty',
          label: 'Qty',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'urate',
          label: 'Unit Rate',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'tcost',
          label: 'Total Cost',
          align: 'center',
          width: '*',
          resize: true
        },

        {
          name: 'start_date',
          label: 'Start Date',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'end_date',
          label: 'End Date',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'duration',
          label: 'Duration',
          align: 'center',
          width: '*',
          resize: true
        },
        // { name: 'dep', label: 'Dep', align: 'center' },
        {
          name: 'add',
          label: ''
        }
      ],

      keep_grid_width: true,
      resize: true,

      grid_resize: true,
      drag_progress: false,
      smart_scales: true,

      drag_links: false,
      show_progress: true,
      grid_resizer_column_attribute: 'col_index',
      layout: {
        css: 'gantt_container',
        cols: [
          {
            width: 1350,
            min_width: 300,
            rows: [
              {
                view: 'grid',
                scrollX: 'gridScroll',
                scrollable: true,
                scrollY: 'scrollVer'
              },
              { view: 'scrollbar', id: 'gridScroll', group: 'horizontal' }
            ]
          },
          { resizer: true, width: 1 },
          {
            rows: [
              { view: 'timeline', scrollX: 'scrollHor', scrollY: 'scrollVer' },
              { view: 'scrollbar', id: 'scrollHor', group: 'horizontal' }
            ]
          },
          { view: 'scrollbar', id: 'scrollVer', height: 20 }
        ]
      }
    };
    gantt.templates.grid_row_class = function(start, end, task) {
      const css = [];
      if (task.task !== '') {
        css.push('subsubitem_bg_color');
        return css.join(' ');
      }
      if (task.subitem !== '' && task.task === '') {
        css.push('subitem_bg_color');
        return css.join(' ');
      }
      if (task.mainItemId !== 0 && task.subitem === '') {
        css.push('mainitem_bg_color');
        return css.join(' ');
      }
      if (task.mainItemId === 0) {
        css.push('project_bg_color');
        return css.join(' ');
      }
    };
    for (const key in config) {
      if (config.hasOwnProperty(key)) {
        gantt.config[key] = config[key];
      }
    }
    gantt.init(this.ganttContainer.nativeElement);
    this.renderer();
  }

  private serializeTask(data: any, insert: boolean = false): TaskV {
    return this.serializeItem(data, insert) as TaskV;
  }

  private serializeItem(data: any, insert: boolean): any {
    const result = {};

    for (const i in data) {
      if (i.charAt(0) === '$' || i.charAt(0) === '_') {
        continue;
      }
      if (insert && i === 'id') {
        continue;
      }
      if (data[i] instanceof Date) {
        result[i] = gantt.templates.xml_format(data[i]);
      } else {
        result[i] = data[i];
      }
    }

    return result;
  }

  formatDate(date: Date) {
    const dat = date;
    const day = dat.getDate();
    const month = dat.getMonth() + 1;
    const year = dat.getFullYear();
    // return [year, month, day].join('-');
    return date;
  }

  dropdownToObj(arr: any[], key: string, value: string, name: string) {
    const dat = arr.reduce((acc, curr) => {
      acc[curr[key]] = curr[value];
      return acc;
    }, {});
    this._storeDropdown[name] = dat;
  }
  submit(task?) {
    console.log(this.ganttForm.value);
    this.ps.addboqvar(this.ganttForm.value).subscribe(res => {
      console.log(res);
      if (res.status) {
        this.subchk = '';
        this.alert.open({
          heading: 'Saved Successfully',
          msg: res.message
        });
        this.saveChnages(task);
        this.closeModal();
        if (task.step > 2) {
          this.getboqItem(1);
          // window.location.reload();
        }
        if (this.countval === 1) {
          if (res.message === 'Saved Successfully') {
            window.location.reload();
          }
        }
      } else {
        this.subchk = 's';
        this.alert.open({
          heading: 'Saving Failed',
          msg: res.message,
          type: 'danger',
          duration: 5000
        });
      }
    });
  }
  closeModal() {
    this.modal.close(this.sampleText.id);
  }
  saveChnages(task) {
    if (this.newTask) {
      gantt.addTask(task, task.dep);
    } else {
      gantt.updateTask(task.id);
      // this.countval--;
    }
    gantt.hideLightbox();
  }
}
