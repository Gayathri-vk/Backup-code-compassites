import { Component, OnInit, ViewChild } from '@angular/core';
import { BOQDetail } from './boqdetailreport';
import { MatTableDataSource, MatPaginator } from '@angular/material';
import { ReportsService } from '../reports.service';
import { Angular2Csv } from 'angular2-csv/Angular2-csv';
import { Angular5Csv } from 'angular5-csv/Angular5-csv';

@Component({
  selector: 'app-boqdetailreport',
  templateUrl: './boqdetailreport.component.html',
  styleUrls: ['./boqdetailreport.component.scss']
})
export class BoqdetailreportComponent implements OnInit {
  BoqdetailList: BOQDetail[];
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
  dataSource = new MatTableDataSource(this.BoqdetailList);
  constructor(private ms: ReportsService) {}

  ngOnInit() {
    this.getbOQAll(0);
    this.dataSource.paginator = this.paginator;
  }
  getbOQAll(id) {
    this.ms.getBOQAll(id).subscribe(res => {
      console.log(res);
      this.BoqdetailList = res;
      this.dataSource.data = this.BoqdetailList;
    });
  }
  exportData() {
    const options = {
      fieldSeparator: ',',
      quoteStrings: '"',
      decimalseparator: '.',
      showLabels: true,
      showTitle: true,
      useBom: true,
      noDownload: true,
      headers: [
        'LOCATION',
        'MAIN ITEMS',
        'SUB-ITEMS',
        'SUB-SUB-ITEMS',
        'BOQ REFERENCE',
        'TASK',
        'UNIT',
        'QUANTITY',
        'UNIT RATE',
        'TOTAL COST',
        'WORK DONE %',
        'WORK DONE DATE',
        'WORK DONE COST',
        'START DATE',
        'END DATE',
        'DURATION'
      ]
    };
    // tslint:disable-next-line:no-unused-expression
    // new Angular2Csv(this.BoqdetailList, 'BOQ Detail Report', options);
    // tslint:disable-next-line:no-unused-expression
    // new Angular5Csv(this.BoqdetailList, 'BOQ Detail Report', options);
    // tslint:disable-next-line:no-unused-expression
    new Angular5Csv(this.BoqdetailList, 'BOQ Detail Report');
  }
  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
