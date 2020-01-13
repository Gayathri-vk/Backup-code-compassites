import { Component, OnInit, AfterViewInit, ViewChild } from '@angular/core';
import { MatTableDataSource } from '@angular/material';

@Component({
  selector: 'app-boq-table',
  templateUrl: './boq-table.component.html',
  styleUrls: ['./boq-table.component.scss']
})
export class BoqTableComponent implements AfterViewInit {
  displayedColumns = [
    'subsubItems',
    'boqref',
    'task',
    'unit',
    'quantity',
    'unitRate',
    'TotalCost'
  ];
  dataSource = new MatTableDataSource(ELEMENT_DATA);

  /**
   * Set the sort after the view init since this component will
   * be able to query its view for the initialized sort.
   */
  ngAfterViewInit() {
    // this.dataSource.sort = this.sort;
  }
}

export interface Element {
  boqref: string;
  subsubItems: string;
  task: string;
  unit: string;
  quantity: number;
  unitRate: number;
  TotalCost: number;
}

const ELEMENT_DATA: Element[] = [
  {
    subsubItems: 'SubSubItem1',
    boqref: '1',
    task: '',
    unit: 'NOS',
    quantity: 0,
    unitRate: 0,
    TotalCost: 0
  },
  {
    subsubItems: 'SubSubItem2',
    boqref: '2',
    task: '',
    unit: 'NOS',
    quantity: 0,
    unitRate: 0,
    TotalCost: 0
  },
  {
    subsubItems: 'SubSubItem3',
    boqref: '3',
    task: '',
    unit: 'NOS',
    quantity: 0,
    unitRate: 0,
    TotalCost: 0
  },
  {
    subsubItems: 'SubSubItem4',
    boqref: '4',
    task: '',
    unit: 'NOS',
    quantity: 0,
    unitRate: 0,
    TotalCost: 0
  }
];
