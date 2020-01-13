import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqvariationreportComponent } from './boqvariationreport.component';

describe('BoqvariationreportComponent', () => {
  let component: BoqvariationreportComponent;
  let fixture: ComponentFixture<BoqvariationreportComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqvariationreportComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqvariationreportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
