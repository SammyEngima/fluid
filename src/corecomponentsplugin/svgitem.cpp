/****************************************************************************
 * This file is part of Fluid.
 *
 * Copyright (c) 2012 Pier Luigi Fiorini
 * Copyright (c) 2010 Marco Martin
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *    Marco Martin <mart@kde.org>
 *
 * $BEGIN_LICENSE:LGPL-ONLY$
 *
 * This file may be used under the terms of the GNU Lesser General
 * Public License as published by the Free Software Foundation and
 * appearing in the file LICENSE.LGPL included in the packaging of
 * this file, either version 2.1 of the License, or (at your option) any
 * later version.  Please review the following information to ensure the
 * GNU Lesser General Public License version 2.1 requirements
 * will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
 *
 * If you have questions regarding the use of this file, please contact
 * us via http://www.maui-project.org/.
 *
 * $END_LICENSE$
 ***************************************************************************/

#include <QPainter>

#include <Fluid/Svg>

#include "svgitem.h"

SvgItem::SvgItem(QQuickItem *parent)
    : QQuickPaintedItem(parent),
      m_smooth(false)
{
    setFlag(QQuickItem::ItemHasContents);
}

SvgItem::~SvgItem()
{
}

void SvgItem::setElementId(const QString &elementID)
{
    if (elementID == m_elementID) {
        return;
    }

    m_elementID = elementID;
    emit elementIdChanged();
    emit naturalSizeChanged();
    update();
}

QString SvgItem::elementId() const
{
    return m_elementID;
}

QSizeF SvgItem::naturalSize() const
{
    if (!m_svg)
        return QSizeF();
    else if (!m_elementID.isEmpty())
        return m_svg.data()->elementSize(m_elementID);

    return m_svg.data()->size();
}


void SvgItem::setSvg(Fluid::Svg *svg)
{
    if (m_svg)
        disconnect(m_svg.data(), 0, this, 0);
    m_svg = svg;
    if (svg) {
        connect(svg, SIGNAL(repaintNeeded()), this, SLOT(updateNeeded()));
        connect(svg, SIGNAL(repaintNeeded()), this, SIGNAL(naturalSizeChanged()));
        connect(svg, SIGNAL(sizeChanged()), this, SIGNAL(naturalSizeChanged()));
    }
    emit svgChanged();
    emit naturalSizeChanged();
}

Fluid::Svg *SvgItem::svg() const
{
    return m_svg.data();
}

void SvgItem::setSmooth(const bool smooth)
{
    if (smooth == m_smooth) {
        return;
    }
    m_smooth = smooth;
    emit smoothChanged();
    update();
}

bool SvgItem::smooth() const
{
    return m_smooth;
}

void SvgItem::paint(QPainter *painter)
{
    if (!m_svg)
        return;

    // Do without painter save, faster and the support can be compiled out
    const bool wasAntiAlias = painter->testRenderHint(QPainter::Antialiasing);
    const bool wasSmoothTransform = painter->testRenderHint(QPainter::SmoothPixmapTransform);
    painter->setRenderHint(QPainter::Antialiasing, m_smooth);
    painter->setRenderHint(QPainter::SmoothPixmapTransform, m_smooth);

    // setContainsMultipleImages has to be done there since m_frameSvg can be shared with somebody else
    m_svg.data()->setContainsMultipleImages(!m_elementID.isEmpty());
    m_svg.data()->paint(painter, boundingRect(), m_elementID);
    painter->setRenderHint(QPainter::Antialiasing, wasAntiAlias);
    painter->setRenderHint(QPainter::SmoothPixmapTransform, wasSmoothTransform);
}

void SvgItem::updateNeeded()
{
    update();
}

#include "moc_svgitem.cpp"