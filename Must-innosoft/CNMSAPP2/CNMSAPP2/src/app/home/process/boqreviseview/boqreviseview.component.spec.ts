import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqreviseviewComponent } from './boqreviseview.component';

describe('BoqreviseviewComponent', () => {
  let component: BoqreviseviewComponent;
  let fixture: ComponentFixture<BoqreviseviewComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqreviseviewComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqreviseviewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
