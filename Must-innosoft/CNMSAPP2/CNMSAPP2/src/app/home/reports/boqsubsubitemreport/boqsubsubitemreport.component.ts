import { Component, OnInit, ViewChild } from '@angular/core';
import { BOQSubSubDetail } from './boqsubsubitemreport';
import { MatPaginator, MatTableDataSource } from '@angular/material';
import { ReportsService } from '../reports.service';
import { Angular2Csv } from 'angular2-csv';

@Component({
  selector: 'app-boqsubsubitemreport',
  templateUrl: './boqsubsubitemreport.component.html',
  styleUrls: ['./boqsubsubitemreport.component.scss']
})
export class BoqsubsubitemreportComponent implements OnInit {
  BoqsubsubList: BOQSubSubDetail[];
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
  dataSource = new MatTableDataSource(this.BoqsubsubList);
  constructor(private ms: ReportsService) {}

  ngOnInit() {
    this.getbOQsubsub(3);
    this.dataSource.paginator = this.paginator;
  }
  getbOQsubsub(id) {
    this.ms.getBOQsubsub(id).subscribe(res => {
      console.log(res);
      this.BoqsubsubList = res;
      this.dataSource.data = this.BoqsubsubList;
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
    new Angular2Csv(
      this.BoqsubsubList,
      'BOQ Sub-Sub-Item Detail Report',
      options
    );
  }
  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
