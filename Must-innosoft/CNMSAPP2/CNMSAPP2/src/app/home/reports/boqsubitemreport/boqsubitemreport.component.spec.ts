import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqsubitemreportComponent } from './boqsubitemreport.component';

describe('BoqsubitemreportComponent', () => {
  let component: BoqsubitemreportComponent;
  let fixture: ComponentFixture<BoqsubitemreportComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqsubitemreportComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqsubitemreportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
