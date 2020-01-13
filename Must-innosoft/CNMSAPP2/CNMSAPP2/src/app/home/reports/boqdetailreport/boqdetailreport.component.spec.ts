import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqdetailreportComponent } from './boqdetailreport.component';

describe('BoqdetailreportComponent', () => {
  let component: BoqdetailreportComponent;
  let fixture: ComponentFixture<BoqdetailreportComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqdetailreportComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqdetailreportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
