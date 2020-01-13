import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import { ProcessService } from '../process.service';
import { NguAlertService } from '@ngu/alert';
import { BoqDescListRes } from './boq';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import {
  FormBuilder,
  Validators,
  FormGroup,
  FormControl
} from '@angular/forms';

export interface IDetail {
  itemName: string;
  category: number;
  purpose: string;
  purchaseDate: string;
  quantity: number;
  // rate: number;
  controlIndex: number;
  location: string;
  mainitem: string;
  subitem: string;
  subsubitem: string;
  boqref: string;
  boqtask: string;
  unit: string;
  qty: number;
  rate: number;
  cost: number;
  workdone: number;
  startdate: string;
  enddate: string;
  dep: string;
}
@Component({
  selector: 'app-boq',
  templateUrl: './boq.component.html',
  styleUrls: ['./boq.component.scss']
})
export class BoqComponent implements OnInit {
  name: string;
  details: IDetail[] = [];
  requisitionForm: FormGroup;
  aRows: any = [];
  iRow: number;
  boqDescList: BoqDescListRes;
  constructor(
    private ps: ProcessService,
    private alert: NguAlertService,
    public builder: FormBuilder
  ) {
    this.name = 'Angular2';
    this.requisitionForm = this.builder.group({});
    this.rowValidateForm(0);
  }
  categories = [
    { id: 1, name: 'KG' },
    { id: 2, name: 'M' },
    { id: 3, name: 'M2' },
    { id: 4, name: 'M3' },
    { id: 3, name: 'No' },
    { id: 4, name: 'Sum' }
  ];
  ngOnInit() {
    this.boqDescList = {
      BoqItems: [
        {
          location: '',
          mainitem: '',
          subitem: '',
          subsubitem: '',
          boqref: '',
          boqtask: '',
          unit: '',
          qty: 0,
          rate: 0,
          cost: 0,
          workdone: 0,
          startdate: '',
          enddate: '',
          dep: ''
        }
      ]
    };
  }
  addboqItems() {
    this.boqDescList.BoqItems.push({
      location: '',
      mainitem: '',
      subitem: '',
      subsubitem: '',
      boqref: '',
      boqtask: '',
      unit: '',
      qty: 0,
      rate: 0,
      cost: 0,
      workdone: 0,
      startdate: '',
      enddate: '',
      dep: ''
    });
  }

  rowValidateForm(i: number, scenario?: string) {
    let action = 'addControl';
    if (scenario === 'remove') {
      action = 'removeControl';
    }
    this.requisitionForm[action](
      'item_name_' + i,
      new FormControl('', [Validators.required])
    );
    this.requisitionForm[action](
      'item_unit_' + i,
      new FormControl('', Validators.required)
    );
    this.requisitionForm[action](
      'item_quantity_' + i,
      new FormControl('', Validators.required)
    );
    this.requisitionForm[action]('item_purpose_' + i, new FormControl('', []));
  }
  addRow() {
    this.details.push(<IDetail>{ controlIndex: this.iRow });
    console.log(this.iRow);
    this.rowValidateForm(this.iRow++, 'add');
  }
  removeRow(index) {
    const controlIndex = this.details[index].controlIndex;
    console.log(index, controlIndex, this.iRow);
    this.details.splice(index, 1);
    this.rowValidateForm(controlIndex, 'remove');
  }
}
