import { OnInit, ElementRef, ViewChild, Component } from '@angular/core';
import { ProcessService } from '../process.service';
import { FormBuilder, FormGroup } from '@angular/forms';
import { NguModalService, NguModal } from '@ngu/modal';
import { NguAlertService } from '@ngu/alert';
import 'dhtmlx-gantt';
import {} from 'dhtmlxgantt';
import { forkJoin } from 'rxjs/observable/forkJoin';
import {
  MainItemMasterDetails,
  ProjectDescriptionDetails,
  Task,
  Boqdep,
  GanttStep,
  Link
} from '../boqdetails/boqdetails';
import { TaskService } from '../boqdetails/task.service';
import { LinkService } from '../boqdetails/link.service';
import { BOQREV } from '../boqrevise/boqrevise';
import { MatOptionSelectionChange } from '@angular/material';

@Component({
  selector: 'app-reviseboq',
  templateUrl: './reviseboq.component.html',
  styleUrls: ['./reviseboq.component.scss'],
  providers: [TaskService, LinkService]
})
export class ReviseboqComponent implements OnInit {
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
  sampleText: NguModal;
  tasklist: Task[];
  tasklnk: any;
  chkpro = 0;
  flg: any;
  Boqdepval: Boqdep[];
  chksubitem: string;
  sfdate: string;
  efdate: string;
  chk1: string;
  chk2: string;
  tid: string;
  task_count_global: any;
  ProjectDescriptionDet: ProjectDescriptionDetails[];
  @ViewChild('gantt_here')
  ganttContainer: ElementRef;
  @ViewChild('myform')
  myform: ElementRef;
  boqrevlist: BOQREV[];
  boqvarrevlist: BOQREV[];
  boqrevcoplist: BOQREV[];
  sampleText1: NguModal;
  chk: any;
  Calenders = [
    { code: '0', name: 'Daily' },
    { code: '1', name: 'Weekly' },
    { code: '2', name: 'Monthly' },
    { code: '3', name: 'Yearly' }
  ];
  Cfromday: any;
  Ctoday: any;
  connection;

  constructor(
    private ps: ProcessService,
    private taskService: TaskService,
    private linkService: LinkService,
    private fb: FormBuilder,
    private modal: NguModalService,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.getdescription(1);
    this.getmainItemDet(2);
    this.ganttConfig();
    this.initForm();
    this.initGantt();
    this.getreviseItem(0);
    this.setholiday();
    this.sampleText1 = {
      id: 'sampleTextID1',
      backdrop: false,
      width: { xs: '100%', sm: '80%', md: '1200px', lg: '1400px' }
    };
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '400px', lg: '400px' }
    };
    gantt.config.open_tree_initially = true;
    //    this.Expanding();
  }

  initForm() {
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
      start_date: '',
      end_date: '',
      duration: '',
      step: 0,
      flag: '',
      dep: '',
      Predec: '',
      Priority: 0
    });

    this.ganttForm.get('start_date').valueChanges.subscribe(res => {
      const date1: string = res;
      const date2: string = this.efdate;
      const diffInMs: number = Date.parse(date2) - Date.parse(date1);
      console.log(diffInMs);
      const diffInHours: number = diffInMs / 1000 / 60 / 60;
      const diffIndays: number = Math.round(diffInMs / (1000 * 3600 * 24));
      this.ganttForm.patchValue({
        RDuration: diffIndays
      });
    });

    this.ganttForm.get('end_date').valueChanges.subscribe(res => {
      const date1: string = this.sfdate;
      const date2: string = res;
      const diffInMs: number = Date.parse(date2) - Date.parse(date1);
      console.log(diffInMs);
      const diffInHours: number = diffInMs / 1000 / 60 / 60;
      const diffIndays: number = Math.round(diffInMs / (1000 * 3600 * 24));
      this.ganttForm.patchValue({
        RDuration: diffIndays
      });
    });
    this.ganttForm.get('dep').valueChanges.subscribe(res => {
      // console.log(res);

      this.chk1 = res.charAt(0);
      this.chk2 = this.tid.charAt(0);
      console.log(this.chk1);
      console.log(this.chk2);
      // this.chk1 = 'a';
      // this.chk2 = 'a';
      if (this.chk1 !== '') {
        if (this.chk2 !== undefined || this.chk2 !== '') {
          if (this.chk1 === this.chk2) {
            if (res !== '') {
              if (res !== null) {
                this.getboqdep(res, 1, '');
              }
            }
          } else {
            this.alert.open({
              heading: 'Error',
              msg: 'Cannot depend',
              type: 'danger',
              duration: 5000
            });
          }
        }
      }
    });
  }
  setholiday() {
    this.ps.getProjectDet(0).subscribe(res => {
      this.Cfromday = res[0].Fromday;
      this.Ctoday = res[0].Today;

      gantt.setWorkTime({ hours: [res[0].Fromtime, res[0].Totime] });
    });
  }
  getholiday() {
    this.ps.getHoliday(5).subscribe(res => {
      console.log(res);
      // console.log(this.Cfromday);
      // console.log(this.Ctoday);
      if (this.Cfromday === '1' && this.Ctoday === '5') {
        gantt.setWorkTime({ day: 6, hours: false });
        gantt.setWorkTime({ day: 0, hours: false });
      } else if (this.Cfromday === '1' && this.Ctoday === '6') {
        gantt.setWorkTime({ day: 0, hours: false });
      } else if (this.Cfromday === '6' && this.Ctoday === '4') {
        gantt.setWorkTime({ day: 5, hours: false });
      } else if (this.Cfromday === '7' && this.Ctoday === '4') {
        gantt.setWorkTime({ day: 5, hours: false });
        gantt.setWorkTime({ day: 6, hours: false });
      } else {
        gantt.setWorkTime({ day: 6, hours: true });
        gantt.setWorkTime({ day: 0, hours: true });
      }
      // gantt.setWorkTime({ hours: [9, 18] });
      // gantt.setWorkTime({ day: 6, hours: true });
      // gantt.setWorkTime({ day: 0, hours: true });
      // const holidays = ['13-09-2018', '14-09-2018'];

      const format_date = gantt.date.str_to_date('%d-%m-%Y');

      for (let i = 0; i < res.length; i++) {
        const converted_date = format_date(res[i].HolidayDate);
        console.log(converted_date);
        gantt.setWorkTime({ date: converted_date, hours: false });
      }
      gantt.templates.task_cell_class = function(item, date) {
        if (!gantt.isWorkTime(date, 'day')) {
          const css = [];

          css.push('weekend');
          return css.join(' ');
        }
      };

      // const format_date = gantt.date.str_to_date('%d-%m-%Y');

      // for (let i = 0; i < res.length; i++) {
      //   const converted_date = format_date(res[i].HolidayDate);
      //   console.log(converted_date);
      //   // gantt.setWorkTime({ date: converted_date, hours: false });
      //   gantt.templates.task_cell_class = function(item, date) {
      //     if (converted_date.getTime() === date.getTime()) {
      //       console.log('ok');
      //       const css = [];

      //       css.push('weekend');

      //       return css.join(' ');
      //     }
      //   };
      // }
    });
  }
  Reset() {
    window.location.reload();
  }
  renderer() {
    this.getboqItem(6, 7);

    gantt.render();
  }
  getboqdep(id, val, sub) {
    console.log(this.chksubitem);
    this.ps.getBoqdep(id, val, this.chksubitem).subscribe(res => {
      this.Boqdepval = res;
      console.log(res);

      if (this.Boqdepval != null) {
        console.log(this.Boqdepval[0].start_date);
        if (val !== 2) {
          this.setread = 1;
        }
        if (
          this.Boqdepval[0].start_date === null ||
          this.Boqdepval[0].start_date === ''
        ) {
          this.setread = 0;
        }
        if (
          this.Boqdepval[0].start_date === null ||
          this.Boqdepval[0].start_date === ''
        ) {
          this.ganttForm.patchValue({
            start_date: this.Boqdepval[0].start_date
          });
        }
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
  setScaleday() {
    this.setScaleConfig('day');
    this.renderer();
  }
  setScaleweek() {
    this.setScaleConfig('week');
    this.renderer();
  }
  setScalemonth() {
    this.setScaleConfig('month');
    this.renderer();
  }
  setScaleyear() {
    this.setScaleConfig('year');
    this.renderer();
  }
  setScaleall() {
    this.setScaleConfig('all');
  }
  setScaleConfig(level) {
    switch (level) {
      case 'day':
        gantt.config.scale_unit = 'day';
        gantt.config.step = 1;
        gantt.config.date_scale = '%d %M %Y';
        gantt.templates.date_scale = null;
        gantt.config.scale_height = 27;
        gantt.config.subscales = [];
        gantt.render();
        break;
      case 'week':
        const weekScaleTemplate = function(date) {
          const dateToStr = gantt.date.date_to_str('%d %M');
          const endDate = gantt.date.add(
            gantt.date.add(date, 1, 'week'),
            -1,
            'day'
          );
          return dateToStr(date) + ' - ' + dateToStr(endDate);
        };

        gantt.config.scale_unit = 'week';
        gantt.config.step = 1;
        gantt.templates.date_scale = weekScaleTemplate;
        gantt.config.scale_height = 50;

        // gantt.config.subscales = [{ unit: 'day', step: 1, date: '%d, %D' }];
        break;
      case 'month':
        gantt.config.scale_unit = 'month';
        gantt.config.date_scale = '%F, %Y';
        gantt.templates.date_scale = null;

        gantt.config.scale_height = 50;

        // gantt.config.subscales = [{ unit: 'day', step: 1, date: '%j, %D' }];

        break;
      case 'year':
        gantt.config.scale_unit = 'year';
        gantt.config.step = 1;
        gantt.config.date_scale = '%Y';
        gantt.templates.date_scale = null;

        // gantt.config.min_column_width = 50;
        gantt.config.scale_height = 90;
        // gantt.config.subscales = [{ unit: 'month', step: 1, date: '%M' }];
        break;
    }
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

  updateval(task?) {
    const taskval = gantt.getTask(task);
    console.log(taskval);
    this.ps.addboq(taskval, 3).subscribe(res => {
      // console.log(res);S
      if (res.status) {
        this.alert.open({
          heading: 'Updated Successfully',
          msg: res.message
        });
        this.getboqItem(6, 7);
        this.Expanding();
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
  private initGantt() {
    console.log(this.tasklnk);
    gantt.attachEvent('onBeforeLightbox', function(id) {
      const task = gantt.getTask(id);
      const links = task.$target;
      console.log(links);
      const labels = [];
      for (let i = 0; i < links.length; i++) {
        const link = gantt.getLink(links[i]);
        if (link.source) {
          const temp_task = gantt.getTask(link.source);
          if (temp_task) {
            const pred = temp_task.id;
            labels.push(pred);
          }
        }
      }
      task.predecessors = labels.join(',');
      return true;
    });
    gantt.attachEvent('onAfterTaskDrag', function(id, mode, task, original) {
      this.tasklnk = id;
    });
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
    gantt.attachEvent('onBeforeLinkAdd', function(id, link) {
      const sourceTask = gantt.getTask(link.source);
      const targetTask = gantt.getTask(link.target);
      if (sourceTask.boqrefId.charAt(0) === 'M') {
        return false;
      }
      if (sourceTask.boqrefId.charAt(0) === 'P') {
        if (targetTask.boqrefId.charAt(0) === 'S') {
          return false;
        } else {
          return false;
        }
      }
      if (targetTask.boqrefId.charAt(0) === 'M') {
        return false;
      }
      if (targetTask.boqrefId.charAt(0) === 'P') {
        if (sourceTask.boqrefId.charAt(0) === 'S') {
          return false;
        } else {
          return false;
        }
      }
      if (sourceTask.progress <= 100) {
        return true;
      }
    });

    gantt.attachEvent('onBeforeTaskDrag', function(id, mode, e) {
      const taskval1 = gantt.getTask(id);

      console.log(taskval1.boqrefId.charAt(0));
      if (
        taskval1.boqrefId.charAt(0) === 'M' ||
        taskval1.boqrefId.charAt(0) === 'P'
      ) {
        return false;
      }
      if (taskval1.progress <= 100) {
        return true;
      }
    });
    gantt.attachEvent('onAfterTaskUpdate', (id, item) => {
      // this.taskService.update(this.serializeTask(item)).then(res => {
      //   console.log(res);
      //   gantt.refreshData();
      // });

      this.updateval(id);
    });

    gantt.attachEvent('onAfterLinkAdd', (id, item) => {
      this.LinkUpdate();
      // console.log(item.type);
      // this.linkService.insert(this.serializeLink(item, true)).then(response => {
      //   if (response.id !== id) {
      //     gantt.changeLinkId(id, response.id);
      //   }
      // });
    });
    gantt.attachEvent('onAfterLinkUpdate', (id, item) => {
      // console.log(item);
      // this.linkService.update(this.serializeLink(item));
    });
    gantt.attachEvent('onAfterLinkDelete', id => {
      this.LinkUpdate();
      // this.linkService.remove(id);
    });

    gantt.attachEvent('onBeforeGanttRender', function() {
      const range = gantt.getSubtaskDates();
      const scaleUnit = gantt.getState().scale_unit;
      if (range.start_date && range.end_date) {
        gantt.config.start_date = gantt.calculateEndDate(
          range.start_date,
          -4,
          scaleUnit
        );
        gantt.config.end_date = gantt.calculateEndDate(
          range.end_date,
          5,
          scaleUnit
        );
      }
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
      // console.log(this.taskId);
      // console.log(this.flg);
      let task = null;
      task = gantt.getTask(id);
      if (task.progress <= 100) {
        const cond = task.parent;
        const pruce = task.Predec;
        // console.log(pruce);
        if (this.flg === undefined || this.flg === 'null') {
          this.flg = 'P';
        }

        if (this.flg === 'P' || this.flg === 'null') {
          if (!cond) {
          } else {
            const countva = <Task>gantt.getTask(task.parent);

            this.countval = <GanttStep>countva.step;
            this.tid = task.boqrefId;
            console.log(task);
            switch (this.countval) {
              case 0:
                this.countval = this.countval + 1;
                this.ganttForm.patchValue({
                  parent: countva.id,
                  location: task.locationId,
                  mainitem: task.mainItemId,
                  boq: task.boq,
                  qty: task.qty,
                  unit: task.unit,
                  urate: task.urate,
                  tcost: task.tcost,
                  id: task.id
                });
                break;
              case 1:
                this.ganttForm.patchValue({
                  parent: countva.id,
                  id: task.id,
                  Priority: task.Priority
                });
                break;
              case 2:
                this.ganttForm.patchValue({
                  location: countva.locationId,
                  mainitem: countva.mainItemId,
                  subitem: task.subitem,
                  parent: task.parent,
                  id: task.id,
                  Priority: task.Priority
                });

                break;
              case 3:
                this.ganttForm.patchValue({
                  location: countva.locationId,
                  mainitem: countva.mainItemId,
                  subitem: task.subitem,
                  subsubitem: task.subsubitem,
                  qty: task.qty,
                  unit: task.unit,
                  urate: task.urate,
                  tcost: task.tcost,
                  boq: task.boq,
                  task: task.text,
                  start_date: task.start_date,

                  end_date: task.end_date,
                  duration: task.duration,
                  parent: task.parent,
                  id: task.id,
                  dep: task.dep,
                  Predec: pruce,
                  Priority: task.Priority
                });
                this.sfdate = task.start_date;
                this.efdate = task.end_date;
                this.chksubitem = countva.subitem;
                break;
              case 4:
                this.ganttForm.patchValue({
                  location: countva.locationId,
                  mainitem: countva.mainItemId,
                  subitem: task.subitem,
                  subsubitem: task.subsubitem,
                  qty: task.qty,
                  unit: task.unit,
                  urate: task.urate,
                  tcost: task.tcost,
                  boq: task.boq,
                  task: task.text,
                  start_date: task.start_date,
                  end_date: task.end_date,
                  duration: task.duration,
                  parent: task.parent,
                  id: task.id,
                  dep: task.dep,
                  predec: pruce,
                  Priority: task.Priority
                });
                this.sfdate = task.RStartDate;
                this.efdate = task.REndDate;
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
      }
    };
    gantt.hideLightbox = () => {
      this.modal.close(this.sampleText.id);

      this.taskId = null;
      this.newTask = null;
    };
  }

  save() {
    let task: Task;
    task = gantt.getTask(this.taskId);

    const data = this.ganttForm.value;
    this.ganttForm.value.id = task.id;
    // if (task.dep !== '') {
    //   this.chk1 = task.dep.charAt(0);
    // } else if (task.Predec !== '') {
    //   this.chk1 = task.Predec.charAt(0);
    // } else if (task.Predec !== '' || task.dep !== '') {
    //   this.chk2 = task.boqrefId.charAt(0);
    //   // console.log(this.chk1);
    //   // console.log(this.chk2);
    // }
    this.chk1 = '';
    this.chk2 = '';
    if (this.chk1 === this.chk2) {
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
      const currentDate = new Date();
      task.start_date = data.start_date || task.RStartDate;

      task.end_date = data.end_date || task.REndDate;

      const date1: string = task.start_date;
      const date2: string = task.end_date;

      const diffInMs: number = Date.parse(date2) - Date.parse(date1);
      const diffInHours: number = Math.round(diffInMs / 1000 / 60 / 60);

      task.duration = data.duration || diffInHours;

      task.dep = data.dep;
      task.step = this.countval + 1;
      this.ganttForm.patchValue({
        id: task.id,
        start_date: task.start_date,
        end_date: task.end_date,
        duration: task.duration,
        step: task.step,
        locationname: task.text,
        mainitemname: task.name,
        parent: task.parent,
        Priority: task.Priority
      });
      // console.log(this._storeDropdown.location);
      // console.log(task);

      if (task.dep !== '') {
        const predecessorArr = task.dep.split(',');
        for (let i = 0; i < predecessorArr.length; i++) {
          this.task_count_global = '' + this.task_count_global;

          if (
            predecessorArr[i] > this.task_count_global.toString() ||
            predecessorArr[i] === this.task_count_global.toString()
          ) {
            alert('Invalid Predecessor value');
            // task_count_global = task_count_global - 1;
            return false;
          }
        }
      }

      this.submit(task);
    } else {
      this.alert.open({
        heading: 'Warring !!!',
        msg: 'Check depend',
        type: 'danger',
        duration: 5000
      });
    }
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
          width: '*',
          resize: true,
          type: gantt.config.types.project,
          open: true,
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
        // {
        //   name: 'boq',
        //   label: 'BOQ Ref',
        //   width: '*',
        //   resize: true
        // },
        // {
        //   name: 'task',
        //   label: 'Task',
        //   width: '*',
        //   resize: true
        // },
        // { name: 'unit', label: 'Unit', width: '*', resize: true },
        // { name: 'qty', label: 'Qty', width: '*', resize: true },
        // {
        //   name: 'urate',
        //   label: 'Unit Rate',
        //   width: '*',
        //   resize: true
        // },
        // {
        //   name: 'tcost',
        //   label: 'Total Cost',
        //   width: '*',
        //   resize: true
        // },
        {
          name: 'progress',
          label: 'WD Per',
          align: 'right',
          width: '*',
          resize: true
        },
        {
          name: 'Workdonedate',
          label: 'WD Date',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'RStartDate',
          label: 'Start Date',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'REndDate',
          label: 'End Date',
          align: 'center',
          width: '*',
          resize: true
          // editor: dateEditor
        },
        {
          name: 'RDuration',
          label: 'Duration',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'start_date',
          label: 'Revise Start Date',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'end_date',
          label: 'Revise End Date',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'duration',
          label: 'Revise Duration',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'ReviseType',
          label: 'Revise Type',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'HDuration',
          label: 'Holidays',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'Predec',
          // label: 'Predecessor',
          label: 'Successors',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'dep',
          label: 'Predecessor',
          align: 'center',
          width: '*',
          resize: true,
          template: function(task) {
            const links = task.$target;
            const labels = [];
            for (let i = 0; i < links.length; i++) {
              const link = gantt.getLink(links[i]);
              if (link.source) {
                const temp_task = gantt.getTask(link.source);
                if (temp_task) {
                  const pred = gantt.getTask(link.source);
                  labels.push(pred.boqrefId);
                }
              }
            }

            return labels.join(',');
          }
        },
        {
          name: 'Slack',
          label: 'Float',
          align: 'center',
          width: '*',
          resize: true
        }
      ],
      open_tree_initially: true,
      auto_scheduling: true,
      details_on_dblclick: false,
      keep_grid_width: false,
      resize: true,
      fit_tasks: true,
      gantt_layout_content: true,
      gantt_resize: true,
      grid_resize: true,
      drag_progress: false,
      smart_scales: true,
      hideLightbox: true,
      dblclick_create: false,
      // drag_links: false,
      drag_resize: false,
      drag_move: false,
      readonly: true,
      show_progress: true,
      highlight_critical_path: true,
      show_slack: true,
      sort: true,

      scale_unit: 'month',
      date_scale: '%F, %Y',
      subscales: [
        { unit: 'week', step: 1, date: 'Week %W' },
        { unit: 'day', step: 1, date: '%d, %D' }
      ],
      scale_height: 60,
      row_height: 25,
      min_grid_column_width: 100,
      grid_resizer_column_attribute: 'col_index',
      layout: {
        css: 'gantt_container',
        cols: [
          {
            width: 800,
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
    gantt.templates.task_text = function(start, end, task) {
      if (task.subsubitem !== '') {
        return task.boqrefId + ', ' + task.subsubitem;
      }
      if (task.subitem !== '' && task.task === '') {
        return task.boqrefId + ', ' + task.subitem;
      }
      if (task.mainItemId !== 0 && task.subitem === '') {
        return task.boqrefId + ', ' + task.name;
      }
      if (task.mainItemId === 0) {
        return task.boqrefId + ', ' + task.text;
      }
      if (task.subsubitem === '') {
        return task.boqrefId + ', ' + task.task;
      }
    };
    gantt.templates.progress_text = function(start, end, task) {
      if (task.progress === 100) {
        return (
          '<div style=text-align:left;>' +
          Math.round(task.progress) +
          '% </div>'
        );
      }
    };
    gantt.templates.task_class = function(start, end, task) {
      const css = [];

      if (task.mainItemId === 0) {
        css.push('project_bg_color');
        return css.join(' ');
      }
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

  dropdownToObj(arr: any[], key: string, value: string, name: string) {
    const dat = arr.reduce((acc, curr) => {
      acc[curr[key]] = curr[value];
      return acc;
    }, {});
    this._storeDropdown[name] = dat;
  }
  submit(task?) {
    console.log(this.ganttForm.value);
    this.ps.addboq(this.ganttForm.value, 3).subscribe(res => {
      console.log(res);
      if (res.status) {
        this.subchk = '';
        this.alert.open({
          heading: 'Saved Successfully',
          msg: res.message
        });
        this.saveChnages(task);
        this.closeModal();
        // if (task.step > 1) {
        this.getboqItem(6, 7);
        this.Expanding();

        // window.location.reload();
        // }
        if (this.countval === 0) {
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
        this.getboqItem(6, 7);
        this.Expanding();
      }
    });
  }
  closeModal() {
    this.modal.close(this.sampleText.id);
  }
  saveChnages(task) {
    gantt.hideLightbox();
  }
  closeModal1() {
    this.modal.close(this.sampleText1.id);
    this.chk = 0;
  }
  getreviseItem(id) {
    this.ps.getReviseItem(id).subscribe(res => {
      console.log(res);
      this.boqrevlist = res;
    });
  }
  getrevcop(id) {
    this.ps.getReviseItem(id).subscribe(res => {
      console.log(res);
      this.boqrevcoplist = res;
    });
  }
  Freeze() {
    this.modal.open(this.sampleText1.id);
    this.getrevcop(3);
    this.chk = 1;
  }
  Freezesave() {
    if (this.chk === 1) {
      this.boqrevlist[0].ftype = 'F';
      console.log(this.boqrevlist);
      this.ps.boqReviseSubmit(this.boqrevlist).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal1();
          this.getreviseItem(0);
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
  }
  Calenderchange(event: MatOptionSelectionChange, Calende: any) {
    if (event.source.selected) {
      if (Calende.code === '0') {
        this.setScaleday();
      } else if (Calende.code === '1') {
        this.setScaleweek();
      } else if (Calende.code === '2') {
        this.setScalemonth();
      } else if (Calende.code === '3') {
        this.setScaleyear();
      }
    }
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
  LinkUpdate() {
    const linkss = gantt.getLinks();
    // console.log(linkss);
    this.ps.bolinkupdatet(linkss, 4).subscribe(res => {
      // console.log(res);
      if (res.status) {
        this.alert.open({
          heading: 'Updated Successfully',
          msg: res.message
        });
        this.getboqItem(6, 7);
        this.Expanding();
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
  private getboqItem(id, linkId) {
    forkJoin([this.ps.getBoqItem(id), this.ps.getBoqlink(linkId)]).subscribe(
      ([data, links]) => {
        console.log(data, links);
        gantt.unselectTask();
        gantt.clearAll();

        // debugger;

        const task = this.tasklist;

        gantt.unselectTask();
        gantt.clearAll();

        this.flg = 'P';
        console.log(this.flg);
        if (data.length != null) {
          if (data.length > 0) {
            this.countval = data.length;
            this.chkpro = 1;
          }
        }

        gantt.parse({ data, links });
        gantt.config.highlight_critical_path = true;

        gantt.render();

        this.getholiday();
        gantt.config.work_time = true;
      }
    );
  }
}
