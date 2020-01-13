import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqsubsubitemreportComponent } from './boqsubsubitemreport.component';

describe('BoqsubsubitemreportComponent', () => {
  let component: BoqsubsubitemreportComponent;
  let fixture: ComponentFixture<BoqsubsubitemreportComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqsubsubitemreportComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqsubsubitemreportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
