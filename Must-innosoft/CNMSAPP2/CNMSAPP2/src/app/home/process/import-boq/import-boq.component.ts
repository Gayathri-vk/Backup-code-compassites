import { Component, OnInit } from '@angular/core';
import {
	ImportBOQList
} from './import-boq';
import * as XLSX from 'xlsx';
type AOA = any[][];
@Component({
	selector: 'app-import-boq',
	templateUrl: './import-boq.component.html',
	styleUrls: ['./import-boq.component.scss']
})
export class ImportBoqComponent implements OnInit {
	importboqList: ImportBOQList[];
	arr: any[];
	Itemval: any;
	Description: any;
	MainItem: any;
	SubItem: any;
	SubSubItem: any;
	BoqRef: any;
	Task: any;
	Qty: any;
	Unit: any;
	Rate: any;
	Amount: any;
	constructor() { }

	ngOnInit() {
		this.importboqList = [{
			sItem: '',
			Description: '',
			MainItem: '',
			SubItem: '',
			SubSubItem: '',
			BoqRef: '',
			Task: '',
			Qty: '',
			Unit: '',
			Rate: '',
			Amount: ''
		}];
	}
	// tslint:disable-next-line:member-ordering
	data: AOA = [];

	onFileChange(evt: any) {
		/* wire up file reader */
		const target: DataTransfer = <DataTransfer>(evt.target);
		if (target.files.length !== 1) throw new Error('Cannot use multiple files');
		const reader: FileReader = new FileReader();
		reader.onload = (e: any) => {
			/* read workbook */
			const bstr: string = e.target.result;
			const wb: XLSX.WorkBook = XLSX.read(bstr, { type: 'binary' });

			/* grab first sheet */
			const wsname: string = wb.SheetNames[0];
			const ws: XLSX.WorkSheet = wb.Sheets[wsname];

			/* save data */
			this.data = <AOA>(XLSX.utils.sheet_to_json(ws, { header: 1 }));
			// console.log(this.data);
			for (let j = 1; j < this.data.length; ++j) {
				const val = this.data[j];
				console.log(val);
				for (let k = 0; k < val.length; ++k) {
					const valrow = val[k];
					if (k === 0) {
						this.Itemval = valrow;
					} else if (k === 1) {
						this.Description = valrow;
					} else if (k === 2) {
						this.MainItem = valrow;
					} else if (k === 3) {
						this.SubItem = valrow;
					} else if (k === 4) {
						this.SubSubItem = valrow;
					} else if (k === 5) {
						this.BoqRef = valrow;
					} else if (k === 6) {
						this.Task = valrow;
					} else if (k === 7) {
						this.Qty = valrow;
					} else if (k === 8) {
						this.Unit = valrow;
					} else if (k === 9) {
						this.Rate = valrow;
					} else if (k === 10) {
						this.Amount = valrow;
					}

				}
				this.importboqList.push({
					sItem: this.Itemval,
					Description: this.Description,
					MainItem: this.MainItem,
					SubItem: this.SubItem,
					SubSubItem: this.SubSubItem,
					BoqRef: this.BoqRef,
					Task: this.Task,
					Qty: this.Qty,
					Unit: this.Unit,
					Rate: this.Rate,
					Amount: this.Amount
				});
			}
			console.log(this.importboqList);
		};
		reader.readAsBinaryString(target.files[0]);
	}
}