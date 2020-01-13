import { Component, OnInit, ViewChild } from '@angular/core';
import { BOQVarDetail } from './boqvariationreport';
import { MatPaginator, MatTableDataSource } from '@angular/material';
import { ReportsService } from '../reports.service';
import { Angular5Csv } from 'angular5-csv/Angular5-csv';

@Component({
  selector: 'app-boqvariationreport',
  templateUrl: './boqvariationreport.component.html',
  styleUrls: ['./boqvariationreport.component.scss']
})
export class BoqvariationreportComponent implements OnInit {
  BoqvardetailList: BOQVarDetail[];
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
  dataSource = new MatTableDataSource(this.BoqvardetailList);
  constructor(private ms: ReportsService) {}

  ngOnInit() {
    this.getbOQVarAll(4);
    this.dataSource.paginator = this.paginator;
  }
  getbOQVarAll(id) {
    this.ms.getBOQVarAll(id).subscribe(res => {
      console.log(res);
      this.BoqvardetailList = res;
      this.dataSource.data = this.BoqvardetailList;
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
        'START DATE',
        'END DATE',
        'DURATION'
      ]
    };
    // tslint:disable-next-line:no-unused-expression
    new Angular5Csv(this.BoqvardetailList, 'BOQ Variation Report');
  }
  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
