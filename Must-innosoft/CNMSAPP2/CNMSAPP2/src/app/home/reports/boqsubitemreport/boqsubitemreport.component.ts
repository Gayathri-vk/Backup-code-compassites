import { Component, OnInit, ViewChild } from '@angular/core';
import { BOQSubDetail } from './boqsubitemreport';
import { MatPaginator, MatTableDataSource } from '@angular/material';
import { ReportsService } from '../reports.service';
import { Angular2Csv } from 'angular2-csv';

@Component({
  selector: 'app-boqsubitemreport',
  templateUrl: './boqsubitemreport.component.html',
  styleUrls: ['./boqsubitemreport.component.scss']
})
export class BoqsubitemreportComponent implements OnInit {
  BoqsubList: BOQSubDetail[];
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
  dataSource = new MatTableDataSource(this.BoqsubList);
  constructor(private ms: ReportsService) {}

  ngOnInit() {
    this.getbOQsub(2);
    this.dataSource.paginator = this.paginator;
  }
  getbOQsub(id) {
    this.ms.getBOQsub(id).subscribe(res => {
      console.log(res);
      this.BoqsubList = res;
      this.dataSource.data = this.BoqsubList;
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
    new Angular2Csv(this.BoqsubList, 'BOQ Sub-Item Detail Report', options);
  }
  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
