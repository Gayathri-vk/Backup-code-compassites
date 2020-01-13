import { Component, OnInit, ElementRef, ViewChild } from '@angular/core';
import { ProcessService } from '../process.service';
import { Task, Link, GanttStep, HolidayRes } from './boqview';
import 'dhtmlx-gantt';
import { TaskService } from '../boqdetails/task.service';
import { LinkService } from '../boqdetails/link.service';
import { forkJoin } from 'rxjs/observable/forkJoin';
import { MatOptionSelectionChange } from '@angular/material';
@Component({
  selector: 'app-boqview',
  templateUrl: './boqview.component.html',
  styleUrls: ['./boqview.component.scss'],
  providers: [TaskService, LinkService]
})
export class BoqviewComponent implements OnInit {
  countval = 0;
  tasklist: Task[];
  linklist: Link[];
  myid: string;
  chkpro = 0;
  HolidayList: HolidayRes[];
  holidays = [];
  @ViewChild('gantt_here')
  ganttContainer: ElementRef;
  Calenders = [
    { code: '0', name: 'Daily' },
    { code: '1', name: 'Weekly' },
    { code: '2', name: 'Monthly' },
    { code: '3', name: 'Yearly' }
  ];
  Cfromday: any;
  Ctoday: any;
  constructor(
    private ps: ProcessService,
    private taskService: TaskService,
    private linkService: LinkService
  ) {}

  ngOnInit() {
    this.ganttConfig();
    this.initGantt();

    this.setholiday();

    this.getboqItem(5, 4);
    // this.getboqlink(4);
    // this.renderer();
    // gantt.refreshData();

    gantt.config.work_time = true;

    gantt.config.readonly = true;
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
      // const holidays = ['13-09-2018', '14-09-2018'];

      const format_date = gantt.date.str_to_date('%d-%m-%Y');

      for (let i = 0; i < res.length; i++) {
        const converted_date = format_date(res[i].HolidayDate);
        console.log(converted_date);
        gantt.setWorkTime({ date: converted_date, hours: true });
      }
      gantt.templates.task_cell_class = function(item, date) {
        if (!gantt.isWorkTime(date, 'day')) {
          const css = [];

          css.push('weekend');
          return css.join(' ');
        }
      };

      // const css = [];

      // const format_date = gantt.date.str_to_date('%d-%m-%Y');
      // for (let i = 0; i < res.length; i++) {
      //   const converted_date = format_date(res[i].HolidayDate);
      //   console.log(converted_date);
      //   // gantt.setWorkTime({ date: converted_date, hours: false });
      //   gantt.templates.task_cell_class = function(item, date) {
      //     if (converted_date.getTime() === date.getTime()) {
      //       console.log('ok');

      //       css.push('weekend');

      //       return css.join(' ');
      //     }
      //   };
      // }
    });
  }
  Refresh() {
    this.getboqItem(5, 4);
    this.renderer();
    gantt.refreshData();
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
        gantt.config.date_scale = '%d %M';
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

  private ganttConfig() {
    const resourceConfig = {
      link_line_width: 3
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
          resize: true,
          width: '*',
          align: 'center'
        },
        { name: 'subitem', label: 'Sub Item', width: '*', resize: true },
        { name: 'subsubitem', label: 'Sub Sub Item', width: '*', resize: true },
        { name: 'boq', label: 'BOQ Ref', width: '*', resize: true },
        { name: 'task', label: 'Task', width: '*', resize: true },
        {
          name: 'unit',
          label: 'Unit',
          align: 'center',
          width: '*',
          resize: true
        },
        { name: 'qty', label: 'Qty', align: 'right', width: '*', resize: true },
        {
          name: 'urate',
          label: 'Unit Rate',
          align: 'right',
          width: '*',
          resize: true
        },
        {
          name: 'tcost',
          label: 'Total Cost',
          align: 'right',
          width: '*',
          resize: true
        },
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
          name: 'wcost',
          label: 'WD Cost',
          align: 'right',
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
        {
          name: 'RStartDate',
          label: 'Revise Start Date',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'REndDate',
          label: 'Revise End Date',
          align: 'center',
          width: '*',
          resize: true
        },
        {
          name: 'RDuration',
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
      resize: true,
      grid_resize: true,
      open_tree_initially: true,
      keep_grid_width: true,
      smart_rendering: false,
      show_task_cells: false,
      auto_scheduling: true,
      drag_progress: true,
      smart_scales: true,
      show_slack: true,
      // autofit: true,
      // drag_links: false,
      drag_resize: true,
      drag_move: false,
      show_progress: true,
      fit_tasks: true,
      gantt_layout_content: true,
      // show_grid: false,
      // week view
      // scale_unit: 'week',
      // date_scale: 'Week #%W',
      scale_unit: 'month',
      date_scale: '%F, %Y',
      subscales: [
        { unit: 'week', step: 1, date: 'Week %W' },
        { unit: 'day', step: 1, date: '%d, %D' }
      ],
      scale_height: 60,
      row_height: 20,
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

    // gantt.attachEvent('onGridResize', function(old_width, new_width) {
    //   document.getElementById('width_placeholder').innerText = new_width;
    // });
    gantt.templates.progress_text = function(start, end, task) {
      return (
        '<div style=text-align:left;>' + Math.round(task.progress) + '% </div>'
      );
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

    // gantt.attachEvent('onParse', function() {
    //   const range = gantt.getSubtaskDates();

    //   gantt.config.start_date = gantt.date.add(range.start_date, -2, 'month');
    //   gantt.config.end_date = gantt.date.add(range.end_date, 2, 'month');
    // });
    for (const key in config) {
      if (config.hasOwnProperty(key)) {
        gantt.config[key] = config[key];
      }
    }
    gantt.init(this.ganttContainer.nativeElement);
    this.renderer();
  }
  renderer() {
    gantt.render();
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

  private initGantt() {
    gantt.attachEvent('onLinkDblClick', function(id, e) {
      const link = gantt.getLink(id);

      console.log(link);
      // any custom logic here
      return true;
    });
    gantt.attachEvent('onAfterLinkAdd', function(id, item) {
      console.log(id);
      // any custom logic here
    });
    gantt.attachEvent('onAfterLinkUpdate', (id, item) => {
      this.linkService.update(this.serializeLink(item));
    });
    // gantt.attachEvent('onGridResize', function(old_width, new_width) {
    //   document.getElementById('width_placeholder').innerText = new_width;
    // });
  }
  private getboqItem(id, linkId) {
    forkJoin([this.ps.getBoqItem(id), this.ps.getBoqlink(linkId)]).subscribe(
      ([data, links]) => {
        // results[0] is our character
        // results[1] is our character homeworld
        console.log(data, links);
        gantt.unselectTask();
        gantt.clearAll();

        // gantt.config.duration_step = 2;
        gantt.parse({ data, links });

        gantt.render();
        this.getholiday();
        gantt.config.work_time = true;
      }
    );
  }
  Reset() {
    window.location.reload();
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
  showcritical() {
    gantt.config.highlight_critical_path = true;
  }

  showcritical_path() {
    gantt.eachTask(function(task) {
      task.$open = true;
    });
    gantt.templates.task_class = function(start, end, task) {
      const css = [];
      if (task.Criticaltaskid === task.id) {
        css.push('critical_link_color');
        return css.join(' ');
      }
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

    gantt.render();
  }
  // this.ps.getBoqItem(id).subscribe(res => {
  //   // this.tasklist = res;
  //   // const task = this.tasklist;
  //   data = res || [];
  //   gantt.parse({ data });
  // });
}
// private getboqlink(id) {
//   this.ps.getBoqlink(id).subscribe(res => {
//     //  debugger;
//     // this.linklist = res;
//     // const link = this.linklist;
//     // console.log(res);
//     const links = res || [];
//     gantt.parse({ links });
//     // gantt.parse({ data });
//   });
// }
