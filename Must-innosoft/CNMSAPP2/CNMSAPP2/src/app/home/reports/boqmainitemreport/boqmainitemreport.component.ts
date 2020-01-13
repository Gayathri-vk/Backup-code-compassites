import { Component, OnInit, ViewChild } from '@angular/core';
import { MatTableDataSource, MatPaginator } from '@angular/material';
import { BOQMainDetail } from './boqmainitemreport';
import { Angular2Csv } from 'angular2-csv';
import { ReportsService } from '../reports.service';

@Component({
  selector: 'app-boqmainitemreport',
  templateUrl: './boqmainitemreport.component.html',
  styleUrls: ['./boqmainitemreport.component.scss']
})
export class BoqmainitemreportComponent implements OnInit {
  BoqmainList: BOQMainDetail[];
  @ViewChild(MatPaginator) paginator: MatPaginator;
  displayedColumns = [
    'text',
    'name',
    'subitem',
    'subsubitem',
    'boq',
    'task',
    'unit',
    'qty',
    'urate',
    'tcost',
    'progress',
    'Workdonedate',
    'wcost',
    'start_date',
    'end_date',
    'duration'
  ];
  dataSource = new MatTableDataSource(this.BoqmainList);
  constructor(private ms: ReportsService) {}

  ngOnInit() {
    this.getbOQmain(1);
    this.dataSource.paginator = this.paginator;
  }
  getbOQmain(id) {
    this.ms.getBOQmain(id).subscribe(res => {
      console.log(res);
      this.BoqmainList = res;
      this.dataSource.data = this.BoqmainList;
    });
  }
  exportData() {
    const options = {
      // fieldSeparator: ',',
      // quoteStrings: '"',
      decimalseparator: '.',
      showLabels: true,
      showTitle: true,
      useBom: true
    };
    // tslint:disable-next-line:no-unused-expression
    new Angular2Csv(this.BoqmainList, 'BOQ Main-Item Detail Report', options);
  }
  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
