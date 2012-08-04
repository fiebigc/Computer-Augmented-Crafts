
/*
 * Copyright (c) 2010 Karsten Schmidt
 * 
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
 */
 
import toxi.gui.*;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import toxi.geom.Vec2D;
import toxi.util.datatypes.FloatRange;
import controlP5.ControlEvent;
import controlP5.ControlListener;
import controlP5.Controller;
import controlP5.Slider;

public class FloatRangeCustomMinMaxBuilder extends FloatRangeBuilder implements
        GUIElementBuilder {

    @Override
    public List<Controller> createElementsFor(final Object context,
            final Field field, Vec2D pos, String id, String label,
            GUIManager gui) throws IllegalArgumentException,
            IllegalAccessException {
        List<Controller> controllers = new ArrayList<Controller>(2);
        final FloatRange range = (FloatRange) field.get(context);
        Slider s =
                createSlider(gui, id + "_min", range.min, range.max, range.min,
                        pos, "min " + label, new ControlListener() {

                            public void controlEvent(ControlEvent e) {
                                float val = e.value();
                                if (val <= range.max) {
                                    range.min = val;
                                    e.controller().setValueLabel("" + val);
                                } else {
                                    e.controller().changeValue(range.max);
                                }
                            }
                        });
        controllers.add(s);
        s =
                createSlider(gui, id + "_max", range.min, range.max, range.max,
                        pos.add(0, 20), "max " + label, new ControlListener() {

                            public void controlEvent(ControlEvent e) {
                                float val = e.value();
                                if (val >= range.min) {
                                    range.max = val;
                                    e.controller().setValueLabel("" + val);
                                } else {
                                    e.controller().changeValue(range.min);
                                }
                            }
                        });
        controllers.add(s);
        return controllers;
    }

    @Override
    public Vec2D getMinSpacing() {
        return new Vec2D(200, 60);
    }
}
