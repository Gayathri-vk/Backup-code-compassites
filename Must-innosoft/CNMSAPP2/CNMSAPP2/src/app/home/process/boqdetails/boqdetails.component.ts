import { Component, OnInit, ViewChild, ElementRef, Input } from '@angular/core';
import { ProcessService } from '../process.service';
import { ProjectMaster } from '../projectdetails/projectdetails';
import {
  BoqdetailsList,
  Task,
  Link,
  ProjectDescriptionDetails,
  MainItemMasterDetails,
  GanttStep,
  Boqdep
} from './boqdetails';
import 'dhtmlx-gantt';
// import {} from '@types/dhtmlxgantt';
import { TaskService } from './task.service';
// import { LinkService } from './link.service';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguModal, NguModalService } from '@ngu/modal';
import { count } from 'rxjs/operators';
import { NguAlertService } from '@ngu/alert';

@Component({
  selector: 'app-boqdetails',
  templateUrl: './boqdetails.component.html',
  styleUrls: ['./boqdetails.component.scss'],
  providers: [TaskService]
})
export class BoqdetailsComponent implements OnInit {
  _storeDropdown: { [x: string]: any } = {};
  ganttForm: FormGroup;
  countval = 0;
  setread = 0;
  sdate: string;
  subchk: string;
  loc: string;
  taskId: any;
  mainchk: string;
  newTask: number;
  MainItemMasterDet: MainItemMasterDetails[];
  projectList1: ProjectMaster[];
  projectList: any[];
  sampleText: NguModal;
  tasklist: Task[];
  chkpro = 0;
  flg: any;
  Boqdepval: Boqdep[];
  chksubitem: string;
  ProjectDescriptionDet: ProjectDescriptionDetails[];
  @ViewChild('gantt_here')
  ganttContainer: ElementRef;
  @ViewChild('myform')
  myform: ElementRef;

  connection;

  constructor(
    private ps: ProcessService,
    private taskService: TaskService,
    // private linkService: LinkService,
    private fb: FormBuilder,
    private modal: NguModalService,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.getboqItem(5);
    this.getproject(0);
    this.getdescription(1);
    this.ganttConfig();
    this.initGantt();
    this.renderer();
    this.projectList = [
      {
        projectName: 'Project Name',
        projectList: [
          {
            // projectDesc: 'Location',
            // desclist: [
            //   {
            listerName: 'Foundation',
            list: [
              {
                mainName: 'Main Item 1',
                mainList: [
                  {
                    subName: 'Sub Name 1',
                    data: {}
                  }
                ]
              },
              {
                mainName: 'Main Item 2',
                mainList: [
                  {
                    subName: 'Sub Name 1',
                    data: {}
                  }
                ]
              },
              {
                mainName: 'Main Item 3',
                mainList: [
                  {
                    subName: 'Sub Name 1',
                    data: {}
                  }
                ]
              }
            ]
          },
          {
            listerName: 'Basement',
            list: []
          }
          //   ]
          // }
        ]
      }
    ];

    this.getmainItemDet(2);

    this.initForm();
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '400px', lg: '400px' }
    };
  }

  initForm() {
    // this.ganttForm = this.fb.group({
    //   id: '',
    //   location: '',
    //   mainitem: '',
    //   locationname: '',
    //   mainitemname: '',
    //   subitem: '',
    //   parent: '',
    //   subsubitem: ['', Validators.required],
    //   boq: ['', Validators.required],
    //   task: ['', Validators.required],
    //   unit: ['', Validators.required],
    //   qty: [0, Validators.required],
    //   urate: [0, Validators.required],
    //   start_date: ['', Validators.required],
    //   end_date: ['', Validators.required],
    //   duration: [0, Validators.required],
    //   step: 0
    // });

    this.ganttForm = this.fb.group({
      id: '',
      location: '',
      mainitem: '',
      locationname: '',
      mainitemname: '',
      subitem: '',
      parent: '',
      subsubitem: '',
      boq: '',
      task: '',
      unit: '',
      qty: 0,
      urate: 0,
      // start_date: '',
      // end_date: '',
      // duration: '',
      step: 0,
      flag: '',
      dep: ''
    });
    // this.chksubitem = this.tasklist[0].subitem;
    this.ganttForm.get('dep').valueChanges.subscribe(res => {
      console.log(res);

      this.getboqdep(res, 1, '');
    });
  }

  renderer() {
    gantt.render();
  }
  getboqdep(id, val, sub) {
    console.log(this.chksubitem);
    this.ps.getBoqdep(id, val, this.chksubitem).subscribe(res => {
      this.Boqdepval = res;
      console.log(res);

      if (this.Boqdepval != null) {
        this.setread = 1;
        this.ganttForm.patchValue({
          start_date: this.Boqdepval[0].start_date
        });
      } else {
        this.ganttForm.patchValue({
          start_date: ''
        });
        this.setread = 0;
        this.alert.open({
          heading: 'Error',
          msg: 'Cannot depend',
          type: 'danger',
          duration: 5000
        });
      }
    });
  }
  getproject(id) {
    this.ps.getProjectDet(id).subscribe(res => {
      this.projectList1 = res;
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

  getmainItemDet(id) {
    this.ps.getMainItemDet(id).subscribe(res => {
      console.log(res);
      this.MainItemMasterDet = res;
      this.dropdownToObj(
        this.MainItemMasterDet,
        'MainItemId',
        'MainItemName',
        'mainItem'
      );
    });
  }
  private getboqItem(id) {
    let data = [];
    this.ps.getBoqItem(id).subscribe(res => {
      // debugger;
      this.tasklist = res;
      const task = this.tasklist;
      data = res || [];
      gantt.unselectTask();
      gantt.clearAll();
      gantt.parse({ data });
      console.log(data);
      this.flg = task[0].flag;
      console.log(this.flg);
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

    gantt.attachEvent('onAfterTaskAdd', (id, item) => {
      // this.taskService.insert(this.serializeTask(item, true)).then(response => {
      //   if (response.id !== id) {
      //     debugger;
      //     gantt.changeTaskId(id, response.id);
      //   }
      // });
    });
    gantt.attachEvent('onGridResize', function(old_width, new_width) {
      document.getElementById('width_placeholder').innerText = new_width;
    });

    gantt.attachEvent('onAfterTaskUpdate', (id, item) => {
      this.taskService.update(this.serializeTask(item)).then(res => {
        console.log(res);
        gantt.refreshData();
      });
    });
    // gantt.attachEvent('onAfterTaskDelete', id => {
    //   this.taskService.remove(id);
    // });
    // gantt.attachEvent('onAfterLinkAdd', (id, item) => {
    //   this.linkService.insert(this.serializeLink(item, true)).then(response => {
    //     if (response.id !== id) {
    //       gantt.changeLinkId(id, response.id);
    //     }
    //   });
    // });
    // gantt.attachEvent('onAfterLinkUpdate', (id, item) => {
    //   this.linkService.update(this.serializeLink(item));
    // });
    // gantt.attachEvent('onAfterLinkDelete', id => {
    //   this.linkService.remove(id);
    // });
    // Promise.all([this.taskService.get(), this.linkService.get()]).then(
    //   ([data, links]) => {
    //     gantt.parse({ data, links });
    //   }
    // );

    // Add Custom Lightbox https://docs.dhtmlx.com/gantt/snippet/d953d916
    //  this.countval = 1;
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
      console.log(this.flg);
      let task = null;
      task = gantt.getTask(id);
      const cond = task.parent;
      // console.log(gantt.getTask(task.parent));
      // this.countval++;
      // this.ganttForm.reset();
      if (this.flg === undefined || this.flg === 'null') {
        this.flg = 'P';
      }

      if (this.flg === 'P' || this.flg === 'null') {
        if (!cond) {
          if (this.chkpro === 0) {
            this.chkpro = 1;
            task.ProjectId = this.projectList1[0].ProjectId;
            this.loc = 'l';
            task.text = this.projectList1[0].ProjectName;
            task.locationId = task.ProjectId;
            task.mainItemId = '0';
            task.name = '';
            task.subitem = '';
            task.subsubitem = '';
            task.boq = '';
            task.task = task.text;
            task.unit = '';
            task.qty = 0;
            task.urate = 0;
            task.tcost = 0;
            const currentDate = new Date();

            // const dateString = this.projectList1[0].Start_Date;
            // const newDate = new Date(dateString);
            // const dateString1 = this.projectList1[0].End_Date;
            // const newDate1 = new Date(dateString1);
            // task.start_date = newDate;
            // task.end_date = newDate1;
            // const diff = task.start_date.valueOf() - task.end_date.valueOf();
            // task.duration = diff + 1;
            task.dep = '';
            task.step = GanttStep.project;
            gantt.addTask(task, task.parent);
            this.ganttForm.patchValue({
              id: task.id,
              location: task.locationId,
              locationname: task.text,
              mainitem: 0,
              mainitemname: '',
              parent: 0
              // start_date: task.start_date,
              // end_date: task.end_date,
              // duration: task.duration
            });

            // this.ganttForm.value.id = task.id;
            // this.ganttForm.value.location = task.locationId;
            // this.ganttForm.value.locationname = task.text;
            // this.ganttForm.value.mainitem = 0;
            // this.ganttForm.value.mainitemname = '';
            // this.ganttForm.value.start_date = task.start_date;
            // this.ganttForm.value.end_date = task.end_date;
            // this.ganttForm.value.duration = task.duration;
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
          const countva = <Task>gantt.getTask(task.parent);
          this.countval = <GanttStep>countva.step;
          // this.ganttForm.reset();

          switch (this.countval) {
            case 0:
              this.countval = this.countval + 1;
              this.ganttForm.patchValue({
                parent: countva.id,
                id: task.id
              });
              break;
            case 1:
              this.ganttForm.patchValue({
                parent: countva.id,
                id: task.id
              });
              break;
            case 2:
              this.ganttForm.patchValue({
                location: countva.locationId,
                mainitem: countva.mainItemId,
                subitem: '',
                subsubitem: '',
                task: '',
                unit: '',
                urate: 0,
                qty: 0,
                parent: task.parent,
                id: task.id
              });

              break;
            case 3:
              this.ganttForm.patchValue({
                location: countva.locationId,
                mainitem: countva.mainItemId,
                subitem: countva.subitem,
                // start_date: countva.start_date,
                // end_date: countva.end_date,
                // subsubitem: '',
                // task: '',
                // unit: '',
                // urate: 0,
                // parent: task.parent,
                id: task.id
              });
              this.chksubitem = countva.subitem;
              break;
            case 4:
              this.ganttForm.patchValue({
                location: countva.locationId,
                mainitem: countva.mainItemId,
                subitem: countva.subitem,
                // start_date: countva.start_date,
                // end_date: countva.end_date,
                parent: task.parent,
                id: task.id
              });
              this.chksubitem = countva.subitem;
              break;
            case 5: {
              gantt.deleteTask(this.taskId);
              this.alert.open({
                heading: 'Warring !!!',
                msg: 'Add Not Possible',
                type: 'danger',
                duration: 5000
              });
              return;
            }
            //   this.ganttForm.patchValue({
            //     location: countva.locationId,
            //     mainitem: countva.mainItemId,
            //     subitem: countva.subitem,
            //     start_date: countva.start_date,
            //     end_date: countva.end_date,
            //     parent: task.parent,
            //     id: task.id
            //   });

            //   break;
          }

          this.modal.open(this.sampleText.id);
        }
      } else {
        gantt.deleteTask(this.taskId);
        this.alert.open({
          heading: 'Warring !!!',
          msg: 'Add Not Possible,Project is Freezed',
          type: 'danger',
          duration: 5000
        });
        return;
      }
      // let form = null;
      // form = this.getForm();
      // let input = null;
      // input = form.querySelector(`[name='location']`);
      // console.log(input.value);
      // input.focus();
      // input.values = task.text;
      // input = form.querySelector(`[name='mainitem']`);
      // input.values = task.name;
      // // mainchk = task.name;
      // input = form.querySelector(`[name='subitem']`);
      // input.values = task.subitem;
      // input = form.querySelector(`[name='subsubitem']`);
      // input.values = task.subsubitem;
      // // subchk = task.subsubitem;
      // input = form.querySelector(`[name='start_date']`);
      // input.values = task.start_date;

      // input = form.querySelector(`[name='end_date']`);
      // input.values = task.end_date;
      // form.style.display = 'block';

      // form.querySelector(`[name='save']`).onclick = this.save();
      // form.querySelector(`[name='close']`).onclick = this.cancel();
      // form.querySelector(`[name='delete']`).onclick = this.remove();
    };
    gantt.hideLightbox = () => {
      this.modal.close(this.sampleText.id);
      // this.getForm().style.display = '';
      this.taskId = null;
      this.newTask = null;
      // const myRow = this.myform.nativeElement;
      // myRow.hidden = true;
    };
  }

  // getForm() {
  //   // console.log(this.mainchk + '1');
  //   const myRow = this.myform.nativeElement;
  //   if (this.loc !== 'l') {
  //     (myRow.querySelector(
  //       `[name='mainitem']`
  //     ) as HTMLInputElement).readOnly = true;
  //   } else {
  //     (myRow.querySelector(
  //       `[name='mainitem']`
  //     ) as HTMLInputElement).readOnly = false;
  //   }

  //   console.log(1);
  //   if (this.mainchk === '') {
  //     console.log(2);
  //     (myRow.querySelector(
  //       `[name='subitem']`
  //     ) as HTMLInputElement).readOnly = true;
  //   } else {
  //     (myRow.querySelector(
  //       `[name='subitem']`
  //     ) as HTMLInputElement).readOnly = false;
  //   }
  //   if (this.subchk === '') {
  //     (myRow.querySelector(
  //       `[name='subsubitem']`
  //     ) as HTMLInputElement).readOnly = true;
  //     (myRow.querySelector(
  //       `[name='start_date']`
  //     ) as HTMLInputElement).readOnly = true;
  //     (myRow.querySelector(
  //       `[name='end_date']`
  //     ) as HTMLInputElement).readOnly = true;
  //   } else {
  //     (myRow.querySelector(
  //       `[name='subsubitem']`
  //     ) as HTMLInputElement).readOnly = false;
  //     (myRow.querySelector(
  //       `[name='start_date']`
  //     ) as HTMLInputElement).readOnly = false;
  //     (myRow.querySelector(
  //       `[name='end_date']`
  //     ) as HTMLInputElement).readOnly = false;
  //   }
  //   return document.getElementById('my-form');
  // }

  save() {
    let task: Task;
    task = gantt.getTask(this.taskId);
    // const myRow = document.getElementById('my-form');
    // tst = (myRow.querySelector(`[name='location']`) as HTMLInputElement).value;
    // (myRow.querySelector(`[name='location']`) as HTMLInputElement).value = '';
    // // tst = getForm().querySelector(`[name='description']`).value;
    // task.text = tst;
    // tst = (myRow.querySelector(`[name='mainitem']`) as HTMLInputElement).value;
    // (myRow.querySelector(`[name='mainitem']`) as HTMLInputElement).value = '';
    // task.name = tst;
    // this.mainchk = task.name;
    // console.log(this.mainchk);
    // tst = (myRow.querySelector(`[name='subitem']`) as HTMLInputElement).value;
    // (myRow.querySelector(`[name='subitem']`) as HTMLInputElement).value = '';
    // task.subitem = tst;
    // this.subchk = task.subitem;
    // tst = (myRow.querySelector(`[name='subsubitem']`) as HTMLInputElement)
    //   .value;
    // (myRow.querySelector(`[name='subsubitem']`) as HTMLInputElement).value = '';
    // task.subsubitem = tst;
    // tst = (myRow.querySelector(`[name='start_date']`) as HTMLInputElement)
    //   .value;
    // (myRow.querySelector(`[name='start_date']`) as HTMLInputElement).value = '';
    // this.sdate = tst;
    // console.log(this.sdate);
    const data = this.ganttForm.value;
    this.ganttForm.value.id = task.id;
    task.ProjectId = '1';
    task.locationId = data.location || '';
    task.text = this._storeDropdown.location[data.location] || '';
    task.name = this._storeDropdown.mainItem[data.mainitem] || '';
    task.mainItemId = data.mainitem || '';
    task.subitem = data.subitem || '';
    task.subsubitem = data.subsubitem || '';
    task.boq = data.boq || '';
    task.task = data.task || '';
    task.unit = data.unit || '';
    task.qty = data.qty || 0;
    task.urate = data.urate || 0;
    task.tcost = task.urate * task.qty;
    // const currentDate = new Date();
    // task.start_date =
    //   data.start_date ||
    //   new Date(
    //     currentDate.getFullYear(),
    //     currentDate.getMonth(),
    //     currentDate.getDay() - 1
    //   );
    // task.end_date = data.end_date || currentDate;

    // task.duration = data.duration;

    task.dep = data.dep;
    task.step = this.countval + 1;
    this.ganttForm.patchValue({
      id: task.id,
      // start_date: task.start_date,
      // end_date: task.end_date,
      // duration: task.duration,
      step: task.step,
      locationname: task.text,
      mainitemname: task.name,
      parent: task.parent
    });
    console.log(this._storeDropdown.location);
    console.log(task);
    this.submit(task);

    // if (this.sdate !== '') {
    //   task.start_date = this.sdate;
    // }
    // // tslint:disable-next-line:quotemark
    // tst = (myRow.querySelector("[name='end_date']") as HTMLInputElement).value;
    // // tslint:disable-next-line:quotemark
    // (myRow.querySelector("[name='end_date']") as HTMLInputElement).value = '';
    // task.end_date = tst;
    // if (this.newTask) {
    //   gantt.addTask(task, task.dep);
    // } else {
    //   gantt.updateTask(task.id);
    //   // this.countval--;
    // }
    // gantt.hideLightbox();
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
          tree: true,
          color: 'red'
        },
        { name: 'text', label: 'Loation', width: '*', resize: true },
        {
          name: 'name',
          label: 'Main Item',

          width: '*',
          resize: true,
          align: 'center'
        },
        {
          name: 'subitem',
          label: 'Sub Item',
          width: '*',
          resize: true
        },
        {
          name: 'subsubitem',
          label: 'Sub Sub Item',
          width: '*',
          resize: true
        },
        {
          name: 'boq',
          label: 'BOQ Ref',
          width: '*',
          resize: true
        },
        {
          name: 'task',
          label: 'Task',
          width: '*',
          resize: true
        },
        { name: 'unit', label: 'Unit', width: '*', resize: true },
        { name: 'qty', label: 'Qty', width: '*', resize: true },
        {
          name: 'urate',
          label: 'Unit Rate',
          width: '*',
          resize: true
        },
        {
          name: 'tcost',
          label: 'Total Cost',
          width: '*',
          resize: true
        },
        // { name: 'progress', label: 'WD Per' },
        // {
        //   name: 'start_date',
        //   label: 'Start Date',
        //   align: 'center',
        //   width: '*',
        //   resize: true
        // },
        // {
        //   name: 'end_date',
        //   label: 'End Date',
        //   align: 'center',
        //   width: '*',
        //   resize: true
        // },
        // {
        //   name: 'duration',
        //   label: 'Duration',
        //   align: 'center',
        //   width: '*',
        //   resize: true
        // },
        // {
        //   name: 'dep',
        //   label: 'Dep',
        //   align: 'center',
        //   width: '*',
        //   resize: true
        // },
        {
          name: 'add',
          label: ''
        }
      ],
      open_tree_initially: true,
      keep_grid_width: true,
      smart_rendering: false,
      show_task_cells: false,
      resize: true,
      // min_column_width: 100,
      // keep_grid_width: false,
      grid_resize: true,
      drag_progress: false,
      smart_scales: true,
      // autofit: true,
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
      if (task.subsubitem !== '') {
        css.push('subsubitem_bg_color');
        return css.join(' ');
      }
      if (task.subitem !== '' && task.subsubitem === '') {
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
    gantt.attachEvent('onTaskDblClick', function(id, e) {
      gantt.hideLightbox();
      return false;
    });
    gantt.init(this.ganttContainer.nativeElement);
    this.renderer();
  }

  private serializeTask(data: any, insert: boolean = false): Task {
    return this.serializeItem(data, insert) as Task;
  }

  private serializeLink(data: any, insert: boolean = false): Link {
    return this.serializeItem(data, insert) as Link;
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
  Reset() {
    window.location.reload();
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

    this.ps.addboq(this.ganttForm.value, 1).subscribe(res => {
      console.log(res);
      if (res.status) {
        this.subchk = '';
        this.alert.open({
          heading: 'Saved Successfully',
          msg: res.message
        });
        this.saveChnages(task);
        this.closeModal();

        if (this.countval === 0) {
          if (res.message === 'Saved Successfully') {
            window.location.reload();
          }
        }
        if (task.step > 1) {
          this.getboqItem(5);
          // window.location.reload();
        }
        this.Expanding();
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

  Freeze() {
    const dateString = this.projectList1[0].Start_Date;
    const newDate = new Date(dateString);
    const dateString1 = this.projectList1[0].End_Date;
    const newDate1 = new Date(dateString1);
    this.ganttForm.patchValue({
      start_date: newDate,
      end_date: newDate1,
      flag: 'V'
    });
    console.log(this.ganttForm.value);
    this.ps.addboq(this.ganttForm.value, 1).subscribe(res => {
      console.log(res);
      if (res.status) {
        this.alert.open({
          heading: 'Freeze Successfully',
          msg: res.message
        });
        this.getboqItem(5);
      } else {
        this.alert.open({
          heading: 'Saving Failed',
          msg: res.message,
          type: 'danger',
          duration: 5000
        });
      }
    });
  }
  Expanding() {
    gantt.eachTask(function(task) {
      task.$open = true;
    });
    gantt.render();
  }
  collapsing() {
    gantt.eachTask(function(task) {
      task.$open = false;
    });
    gantt.render();
  }
}
