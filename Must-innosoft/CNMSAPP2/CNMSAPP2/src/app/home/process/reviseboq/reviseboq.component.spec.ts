import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ReviseboqComponent } from './reviseboq.component';

describe('ReviseboqComponent', () => {
  let component: ReviseboqComponent;
  let fixture: ComponentFixture<ReviseboqComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ReviseboqComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ReviseboqComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
